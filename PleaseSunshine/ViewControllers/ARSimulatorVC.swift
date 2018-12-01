//
//  ARSimulatorVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARSimulatorVC: UIViewController,ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var newAngleY :Float = 0.0
    private var currentAngleY :Float = 0.0
    private var localTranslatePosition :CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.applyRadius(radius: 5)
        self.sceneView.autoenablesDefaultLighting = true
        
        
        textLabel.text = "Detecting Plane..."
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector
            (longPressed))
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    @objc func longPressed(recognizer :UILongPressGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = self.sceneView.hitTest(touch, options: nil)
        
        if let hitTest = hitTestResults.first {
            
            if let parentNode = hitTest.node.parent {
                
                if recognizer.state == .began {
                    localTranslatePosition = touch
                } else if recognizer.state == .changed {
                    
                    let deltaX = Float(touch.x - self.localTranslatePosition.x)/700
                    let deltaY = Float(touch.y - self.localTranslatePosition.y)/700
                    
                    parentNode.localTranslate(by: SCNVector3(deltaX,0.0,deltaY))
                    self.localTranslatePosition = touch
                    
                }
                
            }
            
        }
        
    }
    
    @objc func panned(recognizer :UIPanGestureRecognizer) {
        
        if recognizer.state == .changed {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            let translation = recognizer.translation(in: sceneView)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                
                if let parentNode = hitTest.node.parent {
                    
                    self.newAngleY = Float(translation.x) * (Float) (Double.pi)/180
                    self.newAngleY += self.currentAngleY
                    parentNode.eulerAngles.y = self.newAngleY
                    
                }
                
            }
            
        }
        else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
    }
    
    @objc func pinched(recognizer :UIPinchGestureRecognizer) {
        
        if recognizer.state == .changed {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                
                let chairNode = hitTest.node
                
                let pinchScaleX = Float(recognizer.scale) * chairNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * chairNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * chairNode.scale.z
                
                chairNode.scale = SCNVector3(pinchScaleX,pinchScaleY,pinchScaleZ)
                
                recognizer.scale = 1
                
            }
        }
        
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        
        if let hitTest = hitTestResults.first {
            
            let chairScene = SCNScene(named: "SolarPanel.dae")!
            guard let chairNode = chairScene.rootNode.childNode(withName: "SolarPanel", recursively: true) else {
                return
            }
            
            chairNode.position = SCNVector3(hitTest.worldTransform.columns.3.x,hitTest.worldTransform.columns.3.y,hitTest.worldTransform.columns.3.z)
            
            self.sceneView.scene.rootNode.addChildNode(chairNode)
        }
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            DispatchQueue.main.async {
                
                self.textLabel.text = "Plane Detected"
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
