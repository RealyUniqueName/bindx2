package ;

import bindx.Bind;
import bindx.IBindable;
import buddy.BuddySuite;
import haxe.rtti.CType;
import haxe.rtti.XmlParser;

using buddy.Should;

class InlineTest extends BuddySuite {
    
    public function new() {
        
        describe("Using @:bindable(inlineSetter=true/false, inlineSignalGetter=true/false)", {
            
            var b:BindableInline;
            var cd:Classdef;
            var foundFields:Int;
                
            before({
                foundFields = 0;
                b = new BindableInline();
                var rttiData:String = untyped BindableInline.__rtti;
                var rtti = new XmlParser().processElement(Xml.parse(rttiData).firstChild());
                cd = switch (rtti) { case TClassdecl(c): c; case _: null; };
            });
                
            it("bindx should generate inline setter", {
                for (c in cd.fields) {
                    switch (c.name) {
                        case "set_str":
                            foundFields ++;
                            c.get.match(RInline).should.be(true);
                        case "set_str2":
                            foundFields ++;
                            c.get.match(RNormal).should.be(true);
                        case _:
                    }
                }
                foundFields.should.be(2);
            });
            
            it("bindx should generate inline signal getter", {
                for (c in cd.fields) {
                    switch (c.name) {
                        case "get_str3Changed":
                            foundFields ++;
                            c.get.match(RInline).should.be(true);
                        case "get_str4Changed":
                            foundFields ++;
                            c.get.match(RNormal).should.be(true);
                        case _:
                    }
                }
                foundFields.should.be(2);
            });
            
        });
    }
}

@:rtti
@:bindable(lazySignal=true)
class BindableInline implements bindx.IBindable {

	@:bindable(inlineSetter=true)
	public var str:String;

	@:bindable(inlineSetter=false)
	public var str2:String;

	@:bindable(inlineSignalGetter=true)
	public var str3:String;

	@:bindable(inlineSignalGetter=false)
	public var str4:String;
    
	public function new() {
	}
}