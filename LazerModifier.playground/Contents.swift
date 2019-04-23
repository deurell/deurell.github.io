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

let geo = SCNBox(
    width: 4,
    height: 4,
    length: 4,
    chamferRadius: 0.5)
let node = SCNNode(geometry: geo)
node.transform = SCNMatrix4MakeRotation(Float.pi * 0.25,1,0,0)
sceneView.scene!.rootNode.addChildNode(node)

let material = geo.firstMaterial!

let fragShader = """
#pragma transparent
#pragma arguments
float3 lazerCol;
#pragma body
float2 uv = _surface.diffuseTexcoord;
float x = 1.0-sin(uv.x*M_PI_F);
x = pow(x,4) - 0.05;
float y = 1.0-sin(uv.y*M_PI_F);
y = pow(y,4)-0.05;

float mx = mix(x,y,0.5);
float3 col = lazerCol * mx;
col *= 4.;
_output.color.rgb = col;
"""

material.shaderModifiers = [.fragment: fragShader]

material.setValue(SCNVector3(0.5, 0.8, 0.5), forKey: "lazerCol")
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
