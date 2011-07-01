package com.newloop.roboteyes.core
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    public class RobotEyes extends Sprite
    {
        private var _testApplication:DisplayObjectContainer;

        public function RobotEyes(applicationMainClazz:Class, parent:Object=null)
        {
            init(applicationMainClazz, parent);
        }

        private function init(applicationMainClazz:Class, isFlex:Boolean=false):void
        {
            _testApplication=new applicationMainClazz() as DisplayObjectContainer;

            RobotEyesMaster.viewRoot=_testApplication;
            if(isFlex)
            {
                return;
            }
			addChild(_testApplication);
        }

        public function get testApplication():*
        {
            return _testApplication;
        }
    }
}