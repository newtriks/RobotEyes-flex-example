/* AS3
 Copyright 2010 Newloop.
 */
package com.newloop.roboteyes.core
{
    import com.newloop.roboteyes.drivers.DisplayObjectDriver;
    import com.newloop.roboteyes.drivers.DisplayObjectDriverList;
    import com.newloop.roboteyes.drivers.InteractiveObjectDriver;
    import com.newloop.roboteyes.drivers.TextFieldDriver;
    import com.newloop.roboteyes.drivers.flex.LabelDriver;
    import com.newloop.roboteyes.drivers.flex.TextInputDriver;
    import com.newloop.roboteyes.drivers.flex.TextAreaDriver;
    import com.newloop.roboteyes.errors.RobotEyesError;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.text.TextField;

    import mx.core.IVisualElementContainer;

    import spark.components.Label;
    import spark.components.TextArea;
    import spark.components.TextInput;

    /**
     *    Class description.
     *
     *    @langversion ActionScript 3.0
     *    @playerversion Flash 9.0
     *
     *    @author Lindsey Fallow
     *    @since  07.01.2010
     */
    public class RobotEyesChief extends Object
    {

        private var _viewRoot:DisplayObjectContainer;

        //--------------------------------------
        // CLASS CONSTANTS
        //--------------------------------------

        //--------------------------------------
        //  CONSTRUCTOR
        //--------------------------------------

        /**
         *    @Constructor
         */
        public function RobotEyesChief()
        {
            super();
        }

        //--------------------------------------
        //  PRIVATE VARIABLES
        //--------------------------------------

        //--------------------------------------
        //  GETTER/SETTERS
        //--------------------------------------

        public function set viewRoot(view:DisplayObjectContainer):void
        {
            _viewRoot=view;
        }

        //--------------------------------------
        //  PUBLIC METHODS
        //--------------------------------------

        public function inViewOf(viewClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriver
        {
            return findContextView(viewClazz, useViewRoot);
        }

        public function getA(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriverList
        {
            if(isIVisualElementContainer(useViewRoot))
                return findFlexInstancesOf(uiClazz, useViewRoot);
            else
                return findInstancesOf(uiClazz, useViewRoot);
        }

        public function getAny(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriver
        {
            if(isIVisualElementContainer(useViewRoot))
                return findAnyFlexInstanceOf(uiClazz, useViewRoot);
            else
                return findAnyInstanceOf(uiClazz, useViewRoot);
        }

        public function getSome(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriverList
        {
            if(isIVisualElementContainer(useViewRoot))
                return findFlexInstancesOf(uiClazz, useViewRoot);
            else
                return findInstancesOf(uiClazz, useViewRoot);
        }

        public function createDriverFor(uiItem:DisplayObject):DisplayObjectDriver
        {
            if(uiItem is TextField)
            {
                return new TextFieldDriver(uiItem as TextField);
            }

            if(uiItem is TextInput)
            {
                return new TextInputDriver(uiItem as TextInput);
            }

            if(uiItem is TextArea)
            {
                return new TextAreaDriver(uiItem as TextArea);
            }

            if(uiItem is Label)
            {
                return new LabelDriver(uiItem as Label);
            }

            if(uiItem is InteractiveObject)
            {
                return new InteractiveObjectDriver(uiItem as InteractiveObject);
            }
            return new DisplayObjectDriver(uiItem);
        }

        public function countChildrenOfType(childClazz:Class, useViewRoot:DisplayObjectContainer):uint
        {
            if(isIVisualElementContainer(useViewRoot))
                return countFlexChildInstancesOf(childClazz, useViewRoot);
            else
                return countChildInstancesOf(childClazz, useViewRoot);
        }

        //--------------------------------------
        //  EVENT HANDLERS
        //--------------------------------------

        //--------------------------------------
        //  PRIVATE & PROTECTED INSTANCE METHODS
        //--------------------------------------

        protected function findInstancesOf(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriverList
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }

            var matchingInstancesArray:Array=[];

            var iLength:uint=useViewRoot.numChildren;
            for(var i:uint=0; i<iLength; i++)
            {
                var nextChild:DisplayObject=useViewRoot.getChildAt(i) as DisplayObject;

                if(nextChild is uiClazz)
                {
                    matchingInstancesArray.push(nextChild);
                }
            }

            if(matchingInstancesArray.length>0)
            {
                return new DisplayObjectDriverList(matchingInstancesArray);
            }

            for(i=0; i<iLength; i++)
            {
                nextChild=useViewRoot.getChildAt(i) as DisplayObject;

                if(nextChild is DisplayObjectContainer)
                {
                    try
                    {
                        var grandChildResult:DisplayObjectDriverList=findInstancesOf(uiClazz, nextChild as DisplayObjectContainer);
                        if(grandChildResult!=null)
                        {
                            return grandChildResult;
                        }
                    }
                    catch(e:RobotEyesError)
                    {
                        //
                    }

                }
            }

            var e:RobotEyesError=new RobotEyesError("RobotEyes couldn't find a "+uiClazz+" inside "+useViewRoot.toString());
            throw(e);
        }

        protected function findFlexInstancesOf(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriverList
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }

            var matchingInstancesArray:Array=[];
            var flexViewToWalk:IVisualElementContainer=IVisualElementContainer(useViewRoot);
            var iLength:uint=flexViewToWalk.numElements;
            for(var i:uint=0; i<iLength; i++)
            {
                var nextChild:DisplayObject=flexViewToWalk.getElementAt(i) as DisplayObject;

                if(nextChild is uiClazz)
                {
                    matchingInstancesArray.push(nextChild);
                }
            }

            if(matchingInstancesArray.length>0)
            {
                return new DisplayObjectDriverList(matchingInstancesArray);
            }
            var grandChildResult:DisplayObjectDriverList;
            for(i=0; i<iLength; i++)
            {
                nextChild=useViewRoot.getChildAt(i) as DisplayObject;

                if(nextChild is DisplayObjectContainer)
                {
                    try
                    {
                        if(nextChild is IVisualElementContainer)
                        {
                            grandChildResult=findFlexInstancesOf(uiClazz, nextChild as DisplayObjectContainer);
                        } else
                        {
                            grandChildResult=findInstancesOf(uiClazz, nextChild as DisplayObjectContainer);
                        }

                        if(grandChildResult!=null)
                        {
                            return grandChildResult;
                        }
                    }
                    catch(e:RobotEyesError)
                    {
                        //
                    }

                }
            }

            var e:RobotEyesError=new RobotEyesError("RobotEyes couldn't find a "+uiClazz+" inside "+useViewRoot.toString());
            throw(e);
        }

        protected function findAnyInstanceOf(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriver
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }

            var nextChild:DisplayObject;

            var iLength:uint=useViewRoot.numChildren;
            for(var i:uint=0; i<iLength; i++)
            {
                nextChild=useViewRoot.getChildAt(i) as DisplayObject;

                if(nextChild is uiClazz)
                {
                    return createDriverFor(nextChild);
                }
            }

            for(i=0; i<iLength; i++)
            {
                nextChild=useViewRoot.getChildAt(i) as DisplayObject;

                if(nextChild is DisplayObjectContainer)
                {
                    try
                    {
                        var grandChildResult:DisplayObjectDriver=findAnyInstanceOf(uiClazz, nextChild as DisplayObjectContainer);
                        if(grandChildResult!=null)
                        {
                            return grandChildResult;
                        }
                    }
                    catch(e:RobotEyesError)
                    {
                        //
                    }

                }
            }

            var e:RobotEyesError=new RobotEyesError("RobotEyes couldn't find a "+uiClazz+" inside "+useViewRoot.toString());
            throw(e);
        }

        protected function findAnyFlexInstanceOf(uiClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriver
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }

            var nextChild:DisplayObject;
            var flexViewToWalk:IVisualElementContainer=IVisualElementContainer(useViewRoot);
            var iLength:uint=flexViewToWalk.numElements;
            for(var i:uint=0; i<iLength; i++)
            {
                nextChild=flexViewToWalk.getElementAt(i) as DisplayObject;

                if(nextChild is uiClazz)
                {
                    return createDriverFor(nextChild);
                }
            }
            var grandChildResult:DisplayObjectDriver;
            for(i=0; i<iLength; i++)
            {
                nextChild=flexViewToWalk.getElementAt(i) as DisplayObject;

                if(nextChild is DisplayObjectContainer)
                {
                    try
                    {
                        if(nextChild is IVisualElementContainer)
                        {
                            grandChildResult=findAnyFlexInstanceOf(uiClazz, nextChild as DisplayObjectContainer)
                        } else
                        {
                            grandChildResult=findAnyInstanceOf(uiClazz, nextChild as DisplayObjectContainer);
                        }
                        if(grandChildResult!=null)
                        {
                            return grandChildResult;
                        }
                    }
                    catch(e:RobotEyesError)
                    {
                        //
                    }

                }
            }

            var e:RobotEyesError=new RobotEyesError("RobotEyes couldn't find a "+uiClazz+" inside "+useViewRoot.toString());
            throw(e);
        }

        protected function findContextView(viewClazz:Class, useViewRoot:DisplayObjectContainer=null):DisplayObjectDriver
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }
            var foundView:DisplayObjectContainer;
            if(useViewRoot is IVisualElementContainer)
            {
                foundView=checkForFlexViewClass(viewClazz, useViewRoot)
            } else
            {
                foundView=checkForViewClass(viewClazz, useViewRoot);
            }
            if(foundView)
            {
                return new DisplayObjectDriver(foundView);
            }

            var e:RobotEyesError=new RobotEyesError("RobotEyes couldn't find a "+viewClazz+" inside "+useViewRoot.toString());
            throw(e);
        }

        protected function checkForViewClass(viewClazz:Class, viewToWalk:DisplayObjectContainer):DisplayObjectContainer
        {
            if(viewToWalk is viewClazz)
            {
                return viewToWalk;
            }
            var iLength:uint=viewToWalk.numChildren;
            for(var i:uint=0; i<iLength; i++)
            {
                var nextChild:DisplayObjectContainer=viewToWalk.getChildAt(i) as DisplayObjectContainer;
                if(nextChild!=null)
                {
                    var walkResults:DisplayObjectContainer=checkForViewClass(viewClazz, nextChild);
                    if(walkResults!=null)
                    {
                        return walkResults;
                    }
                }
            }
            return null;
        }

        protected function checkForFlexViewClass(viewClazz:Class, viewToWalk:DisplayObjectContainer):DisplayObjectContainer
        {
            if(viewToWalk is viewClazz)
            {
                return viewToWalk;
            }
            var flexViewToWalk:IVisualElementContainer=IVisualElementContainer(viewToWalk);
            var iLength:uint=flexViewToWalk.numElements;
            var walkResults:DisplayObjectContainer;
            for(var i:uint=0; i<iLength; i++)
            {
                var nextChild:DisplayObjectContainer=flexViewToWalk.getElementAt(i) as DisplayObjectContainer;
                if(nextChild!=null)
                {
                    if(nextChild is IVisualElementContainer)
                    {
                        walkResults=checkForFlexViewClass(viewClazz, nextChild)
                    } else
                    {
                        walkResults=checkForViewClass(viewClazz, nextChild);
                    }
                    if(walkResults!=null)
                    {
                        return walkResults;
                    }
                }
            }
            return null;
        }

        protected function countChildInstancesOf(childClazz:Class, useViewRoot:DisplayObjectContainer):uint
        {
            var typeCounter:uint=0;

            var iLength:uint=useViewRoot.numChildren;
            for(var i:int=0; i<iLength; i++)
            {
                var nextChild:DisplayObject=useViewRoot.getChildAt(i) as DisplayObject;
                if(nextChild is childClazz)
                {
                    typeCounter++;
                } else if(nextChild is DisplayObjectContainer)
                {
                    typeCounter+=countChildInstancesOf(childClazz, nextChild as DisplayObjectContainer);
                }

            }

            return typeCounter;
        }

        protected function countFlexChildInstancesOf(childClazz:Class, useViewRoot:DisplayObjectContainer):uint
        {
            var typeCounter:uint=0;
            var flexViewRoot:IVisualElementContainer=IVisualElementContainer(useViewRoot);
            var iLength:uint=flexViewRoot.numElements;
            for(var i:int=0; i<iLength; i++)
            {
                var nextChild:DisplayObject=flexViewRoot.getElementAt(i) as DisplayObject;
                if(nextChild is childClazz)
                {
                    typeCounter++;
                } else if(nextChild is DisplayObjectContainer)
                {
                    if(useViewRoot is IVisualElementContainer)
                    {
                        typeCounter+=countFlexChildInstancesOf(childClazz, nextChild as DisplayObjectContainer)
                    } else
                    {
                        typeCounter+=countChildInstancesOf(childClazz, nextChild as DisplayObjectContainer);
                    }
                }

            }

            return typeCounter;
        }

        protected function isIVisualElementContainer(useViewRoot:DisplayObjectContainer):Boolean
        {
            if(useViewRoot==null)
            {
                useViewRoot=_viewRoot;
            }
            return Boolean(useViewRoot is IVisualElementContainer);
        }

        //--------------------------------------
        //  UNIT TESTS
        //--------------------------------------

    }

}
