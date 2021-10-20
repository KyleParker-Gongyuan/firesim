// See LICENSE for license details.

#ifndef __SIMIF_H
#define __SIMIF_H

#include <cassert>
#include <cstring>
#include <sstream>
#include <map>
#include <queue>
#include <random>
#include <gmp.h>
#include <sys/time.h>
#define TIME_DIV_CONST 1000000.0;
typedef uint64_t midas_time_t;

midas_time_t timestamp();

double diff_secs(midas_time_t end, midas_time_t start);

typedef std::map< std::string, size_t > idmap_t;
typedef std::map< std::string, size_t >::const_iterator idmap_it_t;

class simif_t
{
  public:
    simif_t();
    virtual ~simif_t() { }
  private:
    // simulation information
    bool log;
    bool pass;
    uint64_t t;
    uint64_t fail_t;
    // random numbers
    uint64_t seed;
    std::mt19937_64 gen;
    SIMULATIONMASTER_struct * master_mmio_addrs;
    LOADMEMWIDGET_struct * loadmem_mmio_addrs;
    PEEKPOKEBRIDGEMODULE_struct * defaultiowidget_mmio_addrs;
    CLOCKBRIDGEMODULE_struct * clock_bridge_mmio_addrs;
    midas_time_t start_time, end_time;
    uint64_t start_hcycle = -1;
    uint64_t end_hcycle = 0;
    uint64_t end_tcycle = 0;

    std::string blocking_fail = "The test environment has starved the simulator, preventing forward progress.";

    inline void take_steps(size_t n, bool blocking) {
      write(this->master_mmio_addrs->STEP, n);
      if (blocking) while(!done());
    }
    virtual void load_mem(std::string filename);

    bool wait_on(size_t flag_addr, double timeout) {
      midas_time_t start = timestamp();
      while (!read(flag_addr))
        if (diff_secs(timestamp(), start) > timeout)
          return false;
      return true;
    }

    bool wait_on_ready(double timeout) {
      return wait_on(this->defaultiowidget_mmio_addrs->READY, timeout);
    }

    bool wait_on_stable_peeks(double timeout) {
      return wait_on(this->defaultiowidget_mmio_addrs->PRECISE_PEEKABLE, timeout);
    }

  public:
    // Simulation APIs
    virtual void init(int argc, char** argv, bool log = false);
    virtual int finish();
    virtual void step(uint32_t n, bool blocking = true);
    inline bool done() { return read(this->master_mmio_addrs->DONE); }

    // Widget communication
    virtual void write(size_t addr, data_t data) = 0;
    virtual data_t read(size_t addr) = 0;

    virtual ssize_t init_stream(
      int idx,
      size_t buffer_high_addr,
      size_t buffer_low_addr,
      size_t bytes_available_addr,
      size_t bytes_consumed_addr,
      size_t done_init_addr,
      size_t flush_addr,
      size_t flush_done_addr) = 0;
    virtual ssize_t pull(size_t addr, char *data, size_t size) = 0;
    virtual void flush_tohost_stream(size_t addr) = 0;
    virtual ssize_t push(size_t addr, char *data, size_t size) = 0;

    inline void poke(size_t id, data_t value, bool blocking = true) {
      if (blocking && !wait_on_ready(10.0)) {
        if (log) {
          std::string fmt = "* FAIL : POKE on %s.%s has timed out. %s : FAIL\n";
          fprintf(stderr, fmt.c_str(), TARGET_NAME, (const char*) INPUT_NAMES[id], blocking_fail.c_str());
        }
        throw;
      }
      if (log)
        fprintf(stderr, "* POKE %s.%s <- 0x%x *\n", TARGET_NAME, INPUT_NAMES[id], value);
      write(INPUT_ADDRS[id], value);
    }

    inline data_t peek(size_t id, bool blocking = true) {
      if (blocking && !wait_on_ready(10.0)) {
        if (log) {
          std::string fmt = "* FAIL : PEEK on %s.%s has timed out. %s : FAIL\n";
          fprintf(stderr, fmt.c_str(), TARGET_NAME, (const char*) INPUT_NAMES[id], blocking_fail.c_str());
        }
        throw;
      }
      if (log && blocking && !wait_on_stable_peeks(0.1))
        fprintf(stderr, "* WARNING : The following peek is on an unstable value!\n");
      data_t value = read(((unsigned int*) OUTPUT_ADDRS)[id]);
      if (log)
        fprintf(stderr, "* PEEK %s.%s -> 0x%x *\n", TARGET_NAME, (const char*) OUTPUT_NAMES[id], value);
      return value;
    }

    inline data_t sample_value(size_t id) {
      return peek(id, false);
    }

    inline bool expect(size_t id, data_t expected) {
      data_t value = peek(id);
      bool pass = value == expected;
      if (log) {
        fprintf(stderr, "* EXPECT %s.%s -> 0x%x ?= 0x%x : %s\n",
                TARGET_NAME, (const char*)OUTPUT_NAMES[id], value, expected, pass ? "PASS" : "FAIL");
      }
      return expect(pass, NULL);
    }

    inline bool expect(bool pass, const char *s) {
      if (log && s) fprintf(stderr, "* %s : %s *\n", s, pass ? "PASS" : "FAIL");
      if (this->pass && !pass) fail_t = t;
      this->pass &= pass;
      return pass;
    }

    void poke(size_t id, mpz_t& value);
    void peek(size_t id, mpz_t& value);
    bool expect(size_t id, mpz_t& expected);

    // LOADMEM functions
    void read_mem(size_t addr, mpz_t& value);
    void write_mem(size_t addr, mpz_t& value);
    void write_mem_chunk(size_t addr, mpz_t& value, size_t bytes);
    void zero_out_dram();

    uint64_t get_seed() { return seed; };

    // A default reset scheme that holds reset high for pulse_length cycles
    void target_reset(int pulse_length = 5);

    // Returns an upper bound for the cycle reached by the target
    // If using blocking steps, this will be ~equivalent to actual_tcycle()
    uint64_t cycles(){ return t; };
    // Returns the current target cycle of the fastest clock in the simulated system, based
    // on the number of clock tokens enqueued (will report a larger number)
    uint64_t actual_tcycle();
    // Returns the current host cycle as measured by a hardware counter
    uint64_t hcycle();
    uint64_t rand_next(uint64_t limit) { return gen() % limit; }

    void record_start_times();
    void record_end_times();
    uint64_t get_end_tcycle() { return end_tcycle; }
    void print_simulation_performance_summary();
};

class StreamHandler {
  public:
    StreamHandler(size_t buffer_high_addr, size_t buffer_low_addr, size_t bytes_available_addr, size_t bytes_consumed_addr, size_t done_init_addr, void* buffer_base, size_t buffer_phys_addr, size_t flush_addr, size_t flush_done_addr, simif_t* sim):
        addr_hi(buffer_high_addr),
        addr_lo(buffer_low_addr),
        bytes_available_addr(bytes_available_addr),
        bytes_consumed_addr(bytes_consumed_addr),
        done_init_addr(done_init_addr),
        buffer_base(buffer_base),
        buffer_phys_addr(buffer_phys_addr),
        flush_addr(flush_addr),
        flush_done_addr(flush_done_addr),
        sim(sim) {
      sim->write(addr_hi, buffer_phys_addr >> 32);
      sim->write(addr_lo, buffer_phys_addr);
      sim->write(done_init_addr, 1);
    };

    size_t bytes_available() { return sim->read(bytes_available_addr); };

    size_t pull(char* data, size_t size) {
      assert(size <= PCIM_CIRCULAR_BUFFER_SIZE);
      size_t bytes_in_buffer = sim->read(bytes_available_addr);
      if (bytes_in_buffer < size) {
        return 0;
      }

      void* src_addr = (char*)buffer_base + offset;
      size_t first_copy_bytes = ((offset + size) > PCIM_CIRCULAR_BUFFER_SIZE) ? PCIM_CIRCULAR_BUFFER_SIZE - offset : size;
      printf("dst %x, src: %x, size: %d\n", data, src_addr, size);
      std::memcpy(data, src_addr, first_copy_bytes);
      if (first_copy_bytes < size) {
        printf("Secondary memcopy dst %x, src: %x, size: %d\n", (char*) data + first_copy_bytes, buffer_base, size - first_copy_bytes);
        std::memcpy((char*) data + first_copy_bytes, buffer_base, size - first_copy_bytes);
      }
      offset = (offset + size) % PCIM_CIRCULAR_BUFFER_SIZE;
      sim->write(bytes_consumed_addr, size);
      return size;
    }

    void flush() {
      sim->write(flush_addr, 1);
      fprintf(stderr, "Driver: Flushing\n");
      printf("Driver: Flushing\n");
      // TODO: Consider if this should be made non blocking // alternate API
      auto flush_done = false;
      while (!flush_done) {
        flush_done = (sim->read(flush_done_addr) & 1);
        fprintf(stderr, "Flush in progress? %d\n", flush_done);
      }
    }

  private:
    unsigned offset = 0;
    const size_t addr_hi;
    const size_t addr_lo;
    const size_t bytes_available_addr;
    const size_t bytes_consumed_addr;
    const size_t done_init_addr;
    const void*  buffer_base;
    const size_t buffer_phys_addr;
    const size_t flush_addr;
    const size_t flush_done_addr;
    simif_t* sim;
};

#endif // __SIMIF_H
