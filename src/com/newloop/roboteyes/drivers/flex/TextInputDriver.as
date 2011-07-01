package com.newloop.roboteyes.drivers.flex
{
    import com.newloop.roboteyes.drivers.*;
    import flash.events.Event;

    import spark.components.TextInput;
    import spark.events.TextOperationEvent;

    public class TextInputDriver extends InteractiveObjectDriver
    {

        private var _textInput:TextInput;

        public function TextInputDriver(tf:TextInput)
        {
            _textInput=tf;
            super(_textInput);
        }

        public function get textInput():TextInput
        {
            return _textInput;
        }

        public function enterText(newText:String):void
        {
            _textInput.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            _textInput.text=newText;
            _textInput.dispatchEvent(new Event(Event.CHANGE))
        }

        public function appendText(newText:String):void
        {
            _textInput.appendText(newText);
        }

        public function checkText(testText:String):Boolean
        {
            return _textInput.text==testText;
        }

        public function getText():String
        {
            return _textInput.text;
        }

        public function textIs(testText:String):Boolean
        {
            return checkText(testText);
        }

        public function isEmpty():Boolean
        {
            if(_textInput.text==null)
            {
                return true;
            }
            return !_textInput.text.length;
        }

        public function isNotEmpty():Boolean
        {
            return !isEmpty();
        }

        public function isBlank():Boolean
        {
            return !hasText(_textInput.text);
        }

        public function isNotBlank():Boolean
        {
            return hasText(_textInput.text);
        }

        public function contains(testText:String):Boolean
        {
            return __contains(_textInput.text, testText);
        }

        public function isNumeric():Boolean
        {
            return __isNumeric(_textInput.text);
        }

        public function wordCountIs(noWords:uint):Boolean
        {
            return (wordCount(_textInput.text)==noWords);
        }

        /**
         *     Functions taken from String Utilities class by Ryan Matsikas, Feb 10 2006
         *
         *    Visit www.gskinner.com for documentation, updates and more free code.
         *     You may distribute this code freely, as long as this comment block remains intact.
         */

        /**
         *    Determines whether the specified string contains any instances of p_char.
         *
         *    @param p_string The string.
         *
         *    @param p_char The character or sub-string we are looking for.
         *
         *    @returns Boolean
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function __contains(p_string:String, p_char:String):Boolean
        {
            if(p_string==null)
            {
                return false;
            }
            return p_string.indexOf(p_char)!=-1;
        }


        /**
         *    Determines whether the specified string contains text.
         *
         *    @param p_string The string to check.
         *
         *    @returns Boolean
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function hasText(p_string:String):Boolean
        {
            var str:String=removeExtraWhitespace(p_string);
            return !!str.length;
        }


        /**
         *    Determines whether the specified string is numeric.
         *
         *    @param p_string The string.
         *
         *    @returns Boolean
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function __isNumeric(p_string:String):Boolean
        {
            if(p_string==null)
            {
                return false;
            }
            var regx:RegExp=/^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
            return regx.test(p_string);
        }

        /**
         *    Determins the number of words in a string.
         *
         *    @param p_string The string.
         *
         *    @returns uint
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function wordCount(p_string:String):uint
        {
            if(p_string==null)
            {
                return 0;
            }
            return p_string.match(/\b\w+\b/g).length;
        }

        /**
         *    Removes whitespace from the front and the end of the specified
         *    string.
         *
         *    @param p_string The String whose beginning and ending whitespace will
         *    will be removed.
         *
         *    @returns String
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function trim(p_string:String):String
        {
            if(p_string==null)
            {
                return '';
            }
            return p_string.replace(/^\s+|\s+$/g, '');
        }

        /**
         *    Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
         *    specified string.
         *
         *    @param p_string The String whose extraneous whitespace will be removed.
         *
         *    @returns String
         *
         *     @langversion ActionScript 3.0
         *    @playerversion Flash 9.0
         *    @tiptext
         */
        private function removeExtraWhitespace(p_string:String):String
        {
            if(p_string==null)
            {
                return '';
            }
            var str:String=trim(p_string);
            return str.replace(/\s+/g, ' ');
        }

    }
}
