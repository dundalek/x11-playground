import xcb
import xcb.xinerama
import xcb.randr
import cStringIO
from xcb import xproto
from struct import pack

from pprint import pprint

class list_screen_info_example:
    """Query information about the screen use root window by default
    check for XINERAMA and query information if its available
    check for RANDR and query information if available"""

    def __init__(self):
        self.xserver = xcb.connect()
        self.xclient = self.xserver.core
        self.setup = self.xserver.get_setup()

        self.canvas = self.setup.roots[0]
        self.root_window = self.canvas.root
        self.depth = self.setup.roots[0].root_depth
        self.visual = self.setup.roots[0].root_visual

        print('Desktop size and depth')
        root_window_info = self.xclient.GetGeometry(self.root_window).reply()
        print(root_window_info.width, root_window_info.height, root_window_info.depth)

        self.extension_xinerama()
        self.extension_randr()

    def extension_xinerama(self):
        extension = self.xclient.QueryExtension(len('XINERAMA'), 'XINERAMA').reply()
        if extension.present != 1:
            print("XINERAMA not available")
            return 
        xinerama = self.xserver(xcb.xinerama.key)
        version = xinerama.QueryVersion(xcb.xinerama.MAJOR_VERSION, xcb.xinerama.MINOR_VERSION).reply()
        print("\n--- XINERAMA Extension %d.%d --- " % (version.major, version.minor))
        data = xinerama.GetScreenCount(self.root_window).reply()
        print('screens = ' + str(data.screen_count))

    def extension_randr(self):
        #test extension is present
        extension = self.xclient.QueryExtension(len('RANDR'), 'RANDR').reply()
        if extension.present != 1:
            print("RANDR not available")
            return 
        
        # query extension version
        randr = self.xserver(xcb.randr.key)
        version = randr.QueryVersion(xcb.randr.MAJOR_VERSION, xcb.randr.MINOR_VERSION).reply()
        print("\n--- RANDR Extension %d.%d --- " % (version.major_version, version.minor_version))

        # scan and see what screen resources exists and the possible modes
        print('Screen Resources')
        data = randr.GetScreenResources(self.root_window).reply()
        outputs = data.outputs
        crtc = data.crtcs
        print('%s screens with output ids %s' % (str(data.num_outputs), ' '.join([str(o) for o in data.outputs])))
        print('%s CRT controllers with ids %s' % (str(data.num_crtcs), ' '.join([str(o) for o in data.crtcs])))
        mode_list = {}
        for mode in data.modes[0:]:
            mode_list[mode.id] = mode
            #print('mode id=%s %sx%s' % (mode.id, mode.width, mode.height))
            pprint (vars(mode))        
        
        #get moer detail info about the crts resolution
        print('\nCrt Info')
        for crt in crtc:
            data = randr.GetCrtcInfo(crt, xcb.xproto.Time.CurrentTime).reply()
            print 'crt ', crt
            if data.outputs:
                print data.outputs[0:]
                #print data.x, data.y, data.width, data.height
                pprint (vars(data))
                print 'GetCrtcGammaSize'
                pprint (vars(randr.GetCrtcGammaSize(crt).reply()))
                print 'GetCrtcGamma'
                pprint (vars(randr.GetCrtcGamma(crt).reply()))
                # transform throws
                #print 'GetCrtcTransform'
                #pprint (vars(randr.GetCrtcTransform(crt).reply()))
                print 'GetPanning'
                pprint (vars(randr.GetPanning(crt).reply()))
            

        print('\nScreen Info')
        #get detailed info about screen capabilites max and min dimensions
        # sreen info throws
        # data = randr.GetScreenInfo(self.root_window).reply()
        # for size in data.sizes[0:]:
        #     print('%d %d %d %d' % (size.height, size.mheight, size.mwidth, size.width))
        print ('GetScreenSizeRange')
        pprint (vars(randr.GetScreenSizeRange(self.root_window).reply()))
        

        primaryOutput = randr.GetOutputPrimary(self.root_window).reply()
        print 'PrimaryOutput:', primaryOutput.output

        # get information about the screens like if there connected
        # display the modes available for connected screens
        # connection states = XCB_RANDR_CONNECTION_CONNECTED = 0, XCB_RANDR_CONNECTION_DISCONNECTED = 1, XCB_RANDR_CONNECTION_UNKNOWN = 2
        print('\nScreen output info')
        for output in outputs:
            data = randr.GetOutputInfo(output, xcb.xproto.Time.CurrentTime).reply()
            if data.connection == 0:
                print(''.join([chr(c) for c in data.name]) + ' Connected')
                for mode in data.modes[0:]:
                    print(str(mode_list[mode].width) + 'x' + str(mode_list[mode].height))
            else:
                print(''.join([chr(c) for c in data.name]) + ' Not Connected')
            pprint (vars(data))
            atoms = randr.ListOutputProperties(output).reply().atoms
            for a in atoms:
                print a
                pprint (vars(randr.QueryOutputProperty(output, a).reply()))
                #print ' '.join([str(a) for a in atoms])

        print ('\nProviders')
        for provider in randr.GetProviders(self.root_window).reply().providers:
            print provider
            data = randr.GetProviderInfo(provider, xcb.xproto.Time.CurrentTime).reply()
            pprint (vars(data))
            for a in randr.ListProviderProperties(provider).reply().atoms:
                print a
                pprint (vars(randr.QueryProviderProperty(provider, a).reply()))
                

        # version 1.5
        #print ('\nMonitors')
        #for x in randr.GetMonitors(self.root_window, False).reply().monitors:
        #    pprint (x)

if __name__ == "__main__":
    list_screen_info_example()
