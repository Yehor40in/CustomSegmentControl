 # CustomSegmentControl

 ![Demo](demo/customsegmentgif.gif)

 # Usage

* If you would like to customize control with Interace builder, create and connect referencing outlets to ```CustomSegmentControl```. 
* Don't forget to specify file's owner for your ```.xib``` file and mention it during initialization.
Change ```optionsCount``` and ```cornerRadius``` properties to make this control fit your design.
* Set your titles in ```titles``` array property.

* Make sure your controller conforms to ```CustomSegmentControlDelegate```, for example:

```

class MyViewController: UIVIewController, CustomSegmentControlDelegate {
  var control: CustomSegmentControl! 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    control = CustomSegmentControl(frame: CGRect(x: 100, y: 100, width: 300, height: 50))
    
    control.delegate = self
 
    view.addSubview(control)
  }
  
  func customSegmentControl(_ segmentControl: CustomSegmentControl didChangeValue value: Int) {
    // Your code goes here
    // triggers when segmentControl changed value
  }
}
```

# Contribution & Usage

Download the project to see example.
Feel free to play around with this control and add your customizations
