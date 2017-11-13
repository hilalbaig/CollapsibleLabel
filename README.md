# CollapsibleLabel
Collapsible Label add feature to default UILabel to facilitate accessing and navigating content of UILabel by allowing your users to expand or collapse content within a label, hiding long text passages when no longer needed.

# Usage

        //Label from Storyboard without autoExpand
        lblTop.moreTitle = "Read more"
        lblTop.wrapAfterIndex = 15
        lblTop.moreClicked = {
            print("More taped")
        }
        lblTop.noneClicked = {
            print("-- None taped")
        }
        
        
        
        //Label from Storyboard with autoExpand
        lblMore.moreTitle = "Read more"
        lblMore.lessTitle = "Read less"
        lblMore.autoExpand = true
        lblMore.wrapAfterIndex = 15
        lblMore.moreClicked = {
            print("More taped")
        }
        lblMore.lessClicked = {
            print("Less taped")
        }
        lblMore.noneClicked = {
            print("-- None taped")
        }
        
        
        
        //Label programmatically without autoExpand
        let label = CollapsibleLabel(frame: CGRect(x: 20, y: 150, width: 200, height: 21))
        label.text = "I'am a test label."
        label.moreTitle = "Read more"
        label.wrapAfterIndex = 18
        label.moreClicked = {
            print("More taped")
        }
        label.noneClicked = {
            print("-- None taped")
        }
        self.view.addSubview(label)
        
        
        
        //Label programmatically without autoExpand
        let label2 = CollapsibleLabel(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width-20, height: 50))
        label2.text = "I'am a test label and i can be expanded as well."
        label2.moreTitle = "Read more"
        label2.lessTitle = "Read less"
        label2.autoExpand = true
        label2.wrapAfterIndex = 18
        label2.moreClicked = {
            print("More taped")
        }
        label2.lessClicked = {
            print("Less taped")
        }
        label2.noneClicked = {
            print("-- None taped")
        }
        self.view.addSubview(label2)
