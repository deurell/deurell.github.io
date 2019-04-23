import UIKit
import SceneKit
import PlaygroundSupport

let frame = CGRect(
    x: 0,
    y: 0,
    width: 400,
    height: 200)
let sceneView = SCNView(frame: frame)
sceneView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
sceneView.showsStatistics = false
sceneView.autoenablesDefaultLighting = false
sceneView.allowsCameraControl = true
sceneView.scene = SCNScene()

let cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3(x: 0, y: 0, z: 12)
sceneView.scene!.rootNode.addChildNode(cameraNode)

let geo = SCNPlane(width: 6, height: 6)

geo.firstMaterial?.diffuse.contents = UIImage(named: "skull.jpg")
geo.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat;
geo.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat;

let node = SCNNode(geometry: geo)
node.transform = SCNMatrix4MakeRotation(Float.pi * 0,1,0,0)
sceneView.scene!.rootNode.addChildNode(node)

let material = geo.firstMaterial!

let fragShader = """
#pragma transparent
#pragma body

float mpi = 3.1415926535897932384626433832795;
// scenekit stashes time in scn_frame
float iTime = scn_frame.time;

// grab uv coords from our material
float2 uv = _surface.diffuseTexcoord;

// we want a coords from -1 to 1 instead of standard uv coords (0-1)
float2 p = -1.0+2.0*uv;

// length and angle from center for fancy polar coord dist.
float r = length(p);
float a = atan(p.y / p.x);

//classic demo fx
float2 uvmod = float2(p.x/abs(p.y), 1/abs(p.y));

// uv scroll it with time
uvmod += iTime;

// get the diffuse sampler and get col at distorted uv coords
float4 texcol = u_diffuseTexture.sample(u_diffuseTextureSampler, uvmod);
_output.color.rgba = texcol;
"""

material.shaderModifiers = [.fragment: fragShader]

material.setValue(SCNVector3(0.5, 0.8, 0.5), forKey: "lazerCol")

sceneView.isPlaying = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
