/** @author: Simon Bailey <simon@newtriks.com> */
package com.newtriks.views
{
    import asunit.asserts.assertNotNull;
    import asunit.asserts.assertSame;
    import asunit.asserts.assertTrue;

    import flash.display.Sprite;

    use namespace assertTrue;

    public class LoggerTest
    {
        [Inject]
        public var context:Sprite;

        private var logger:Logger;

        [Before]
        public function setUp():void
        {
            logger=new Logger();
            context.addChild(logger);
        }

        [After]
        public function tearDown():void
        {
            logger=null;
        }

        [Test]
        public function instantiated():void
        {
            assertTrue(logger is Logger);
        }

        [Test]
        public function logger_has_textarea():void
        {
            assertNotNull(logger.logger_txt);
        }

        [Test]
        public function logger_text_is_populated():void
        {
            logger.logger_txt.text="Hello World";
            assertSame(logger.logger_txt.text, "Hello World");
        }
    }
}