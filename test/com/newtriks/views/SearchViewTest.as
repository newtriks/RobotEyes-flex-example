/** @author: Simon Bailey <simon@newtriks.com> */
package com.newtriks.views
{
    import asunit.asserts.assertNotNull;
    import asunit.asserts.assertSame;
    import asunit.asserts.assertTrue;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    use namespace assertTrue;

    public class SearchViewTest
    {
        [Inject]
        public var context:Sprite;

        private var searchView:SearchView;

        [Before]
        public function setUp():void
        {
            searchView=new SearchView();
            context.addChild(searchView);
        }

        [After]
        public function tearDown():void
        {
            searchView=null;
        }

        [Test]
        public function instantiated():void
        {
            assertTrue(searchView is SearchView);
        }

        [Test]
        public function search_view_has_search_textinput():void
        {
            assertNotNull(searchView.searchRequest_txt);
        }

        [Test]
        public function search_view_has_submitbutton():void
        {
            assertNotNull(searchView.submit_btn);
        }

        [Test]
        public function search_text_is_populated():void
        {
            searchView.searchRequest_txt.text="Hello World";
            assertSame(searchView.searchRequest_txt.text, "Hello World");
        }

        [Test]
        public function submit_button_dispatches_specific_eventname():void
        {
            searchView.addEventListener("submitSearchEvent", submitClickHandler);
            searchView.submit_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        private function submitClickHandler(event:Event):void
        {
            assertSame(event.type, "submitSearchEvent");
        }
    }
}