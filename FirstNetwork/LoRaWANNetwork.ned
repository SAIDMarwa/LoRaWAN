import flora.LoraNode.LoRaNode;
import flora.LoraNode.LoRaGW;
import flora.LoRaPhy.LoRaMedium;
import inet.environment.common.PhysicalEnvironment;
import inet.node.inet.StandardHost;
import inet.node.inet.Router;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth1G;
import inet.node.internetcloud.InternetCloud;
import inet.applications.udpapp.UdpBasicApp;


network LoRaWANNetwork
{
    parameters:
        int networkSizeX = default(50000); // Largeur du réseau en mètres
        int networkSizeY = default(50000); // Hauteur du réseau en mètres
        @display("bgb=1000,1000"); // Affiche la taille du réseau
        int numNodes = default(1);
        int numGateways = default(1);
        string physicalEnvironmentModule = default("physicalEnvironment");

    submodules:
        networkServer: StandardHost {
            parameters:
                @display("p=54,39");
        }
        gwRouter[numGateways]: Router {
            @display("p=113,149");
        }
        nsRouter: Router {
            @display("p=212,35");
        }
        internetCloud: InternetCloud {
            @display("p=313,51");
        }

        LoRaMedium: LoRaMedium {
            @display("p=518,38");
        }
        gateway[numGateways]: LoRaGW {
            @display("p=298,130");
        }
        nodes[numNodes]: LoRaNode {
            @display("p=313,217");
        }
        physicalEnvironment: PhysicalEnvironment {
            parameters:
                @display("p=529,105");
        }
    connections:
        networkServer.ethg++ <--> Eth1G <--> nsRouter.ethg++;
        nsRouter.pppg++ <--> Eth1G <--> internetCloud.pppg++;
        for i=0..numGateways-1 {
            internetCloud.pppg++ <--> Eth1G <--> gwRouter[i].pppg++;
            gwRouter[i].ethg++ <--> Eth1G <--> gateway[i].ethg++;
        }
}
