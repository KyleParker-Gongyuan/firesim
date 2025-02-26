// See LICENSE for license details.

package midas.platform

import firrtl.annotations.{Annotation, CircuitName, ReferenceTarget, ModuleTarget}
import firrtl.ir.{Circuit, Port}
import freechips.rocketchip.config.{Parameters}
import freechips.rocketchip.diplomacy.{LazyModule}

import midas.Platform
import midas.core._
import midas.passes.fame.{FAMEChannelConnectionAnnotation}
import midas.widgets.{CStrLit, UInt32, BridgeIOAnnotation}
import midas.widgets.CppGenerationUtils._

/**
  * Generates the platform wrapper (which includes most of the chisel-generated
  * RTL that constitutes the simulator, including BridgeModules) using
  * parameters instance and the required annotations from the transformed
  * target design.
  *
  */
private [midas] object PlatformShim {
  def apply(config: SimWrapperConfig)(implicit p: Parameters): PlatformShim = {
    p(Platform)(p.alterPartial({ case SimWrapperKey => config }))
  }
}

abstract class PlatformShim(implicit p: Parameters) extends LazyModule()(p) {
  val top = LazyModule(new midas.core.FPGATop)
  def genHeader(sb: StringBuilder, target: String) {
    sb.append("#include <stdint.h>\n")
    sb.append("#include <stdbool.h>\n")
    sb.append(genStatic("TARGET_NAME", CStrLit(target)))
    top.module.genHeader(sb)
    sb.append("\n// Simulation Constants\n")
    top.module.headerConsts map { case (name, value) =>
      genMacro(name, UInt32(value)) } addString sb
  }
}
