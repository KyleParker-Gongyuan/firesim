""" These are the base components that make up a FireSim simulation target
topology. """

from runtools.firesim_topology_elements import *
from runtools.user_topology import UserTopologies

from typing import List, Callable

class FireSimTopology(UserTopologies):
    """ A FireSim Topology consists of a list of root FireSimNodes, which
    connect to other FireSimNodes.

    This is designed to model tree-like topologies."""
    custom_mapper: Callable

    def __init__(self, user_topology_name: str, no_net_num_nodes: int) -> None:
        # This just constructs the user topology. an upper level pass manager
        # will apply passes to it.

        super().__init__(no_net_num_nodes)

        # a topology can specify a custom target -> host mapping. if left as None,
        # the default mapper is used, which handles no network and simple networked cases.
        self.custom_mapper = None
        config_func = getattr(self, user_topology_name)
        config_func()

    def get_dfs_order(self) -> List[FireSimNode]:
        """ Return all nodes in the topology in dfs order, as a list. """
        stack = list(self.roots)
        retlist = []
        visitedonce = set()
        while stack:
            nextup = stack[0]
            if nextup in visitedonce:
                if nextup not in retlist:
                    retlist.append(stack.pop(0))
                else:
                    stack.pop(0)
            else:
                visitedonce.add(nextup)
                stack = list(map(lambda x: x.get_downlink_side(), nextup.downlinks)) + stack
        return retlist

    def get_dfs_order_switches(self) -> List[FireSimSwitchNode]:
        """ Utility function that returns only switches, in dfs order. """
        return [x for x in self.get_dfs_order() if isinstance(x, FireSimSwitchNode)]

    def get_dfs_order_servers(self) -> List[FireSimServerNode]:
        """ Utility function that returns only servers, in dfs order. """
        return [x for x in self.get_dfs_order() if isinstance(x, FireSimServerNode)]

    def get_bfs_order(self) -> None:
        """ return the nodes in the topology in bfs order """
        # don't forget to eliminate dups
        assert False, "TODO"

