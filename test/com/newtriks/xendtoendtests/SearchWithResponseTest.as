/**
 * User: newtriks
 * Date: 09/06/2011
 */
package com.newtriks.xendtoendtests
{
    import asunit.asserts.assertNotNull;
    import asunit.asserts.assertTrue;
    import asunit.framework.IAsync;

    import com.newloop.roboteyes.core.RobotFlexEyes;
    import com.newloop.roboteyes.drivers.DisplayObjectDriver;
    import com.newloop.roboteyes.drivers.InteractiveObjectDriver;
    import com.newloop.roboteyes.drivers.flex.TextAreaDriver;
    import com.newloop.roboteyes.drivers.flex.TextInputDriver;
    import com.newloop.roboteyes.getAny;
    import com.newloop.roboteyes.inViewOf;
    import com.newtriks.views.Logger;
    import com.newtriks.views.SearchView;

    import flash.events.MouseEvent;
    import flash.utils.setTimeout;

    import spark.components.Button;
    import spark.components.TextArea;
    import spark.components.TextInput;

    use namespace assertTrue;

    public class SearchWithResponseTest
    {
        [Inject]
        public var async:IAsync;

        private var robotEyes:RobotFlexEyes;
        private var searchApplication:SearchApplication;

        [Before]
        public function setUp():void
        {
            if(robotEyes==null)
            {
                robotEyes=new RobotFlexEyes(SearchApplication, true);
                searchApplication=new SearchApplication();
            }
        }

        [After]
        public function tearDown():void
        {
            robotEyes=null;
        }

        [Test]
        public function failure():void
        {
            assertTrue("Failing test", true);
        }

        [Test]
        public function instantiated():void
        {
            assertTrue(searchApplication is SearchApplication);
        }

        [Test]
        public function robot_eyes_initiated_application():void
        {
            assertTrue(robotEyes.testApplication is SearchApplication);
        }

        [Test]
        public function search_view_created_and_in_searchapplication():void
        {
            var searchViewDriver:DisplayObjectDriver=getAny(SearchView);
            assertNotNull(searchViewDriver.view);
        }

        [Test]
        public function search_logger_created_and_in_searchview():void
        {
            var loggerTextDriver:DisplayObjectDriver=getAny(Logger);
            assertNotNull(loggerTextDriver.view);
        }

        [Test]
        public function search_logger_contains_specific_string():void
        {
            var loggerTextDriver:TextAreaDriver=inViewOf(Logger).getA(TextArea).id("logger_txt") as TextAreaDriver;
            loggerTextDriver.enterText('Hello World');
            assertTrue(loggerTextDriver.textIs('Hello World'));
        }

        [Test]
        public function search_textinput_created_and_in_searchview():void
        {
            var textInputDriver:TextInputDriver=inViewOf(SearchView).getA(TextInput).id("searchRequest_txt") as TextInputDriver;
            assertNotNull(textInputDriver.view);
        }

        [Test]
        public function search_textinput_contains_specific_string():void
        {
            var textInputDriver:TextInputDriver=inViewOf(SearchView).getA(TextInput).id("searchRequest_txt") as TextInputDriver;
            textInputDriver.enterText('Hello World');
            assertTrue(textInputDriver.textIs('Hello World'));
        }

        [Test]
        public function submit_button_created_and_in_search_view():void
        {
            var submitButtonDriver:DisplayObjectDriver=inViewOf(SearchView).getA(Button).id("submit_btn");
            assertNotNull(submitButtonDriver.view);
        }

        [Test]
        public function submit_throws_error_when_empty_search_text():void
        {
            var submitButtonDriver:InteractiveObjectDriver=inViewOf(SearchView).getA(Button).id("submit_btn") as InteractiveObjectDriver;
            submitButtonDriver.click();
            var handler:Function = async.add(submitThrowsErrorClickHandler);
            setTimeout(handler, 0);
        }

        private function submitThrowsErrorClickHandler():void
        {
            var loggerTextDriver:TextAreaDriver=inViewOf(Logger).getA(TextArea).id("logger_txt") as TextAreaDriver;
            assertTrue(loggerTextDriver.textIs("Error: Search input must not be empty!"));
        }

        [Test]
        public function submits_successfully():void
        {
            var submitButtonDriver:InteractiveObjectDriver=inViewOf(SearchView).getA(Button).id("submit_btn") as InteractiveObjectDriver;
            var textInputDriver:TextInputDriver=inViewOf(SearchView).getA(TextInput).id("searchRequest_txt") as TextInputDriver;
            textInputDriver.enterText('Hello World');
            submitButtonDriver.click();
            var handler:Function = async.add(submitClickHandler);
            setTimeout(handler, 0);
        }

        private function submitClickHandler():void
        {
            var loggerTextDriver:TextAreaDriver=inViewOf(Logger).getA(TextArea).id("logger_txt") as TextAreaDriver;
            assertTrue(loggerTextDriver.textIs("You submitted a search request for: Hello World"));
        }
    }
}
