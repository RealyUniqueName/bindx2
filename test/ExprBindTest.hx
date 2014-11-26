package ;

import bindx.Bind;
import bindx.BindxExt;
import bindx.IBindable;
import buddy.BuddySuite;

using buddy.Should;

class ExprBindTest extends BuddySuite {
    
    public function new() {
        
        describe("Using BindExt.expr", {
            
            var callNum:Int;
            var from:String;
            before({
                from = null;
                callNum = 0;
            });
            
            it("BindExt.chain should bind simple expr", {
                var a = new BaseTest.Bindable1();
                var b = new BaseTest.Bindable1();
                a.str = "a1";
                b.str = "b1";
                inline function val() return b.str + "ab".charAt(a.str.length - 2) + Std.string(1);
                
                BindExt.expr(b.str + "ab".charAt(a.str.length - 2) + Std.string(1), function (f, to:String) {
                    f.should.be(from);
                    from = to;
                    to.should.be(val());
                    callNum ++;
                });
                
                callNum.should.be(1);
                
                a.str = "a2";
                
                callNum.should.be(2);
                
                b.str = "b2";
                
                callNum.should.be(3);
            });
            
            it("BindExt.chain should bind complex expresions", {
                var a = new BaseTest.Bindable1();
                var b = new BaseTest.Bindable1();
                var c = new BaseTest.Bindable1();
                a.str = "a1";
                b.str = "";
                c.str = "1";
                inline function val() return if (a.str.charAt(b.str.length) == Std.string(c.str)) 1 else 0;
                var from:Null<Int> = null;
                
                BindExt.expr(if (a.str.charAt(b.str.length) == Std.string(c.str)) 1 else 0, function (f:Null<Int>, to:Null<Int>) {
                    f.should.be(from);
                    from = to;
                    to.should.be(val());
                    callNum ++;
                });
                
                callNum.should.be(1);
                
                b.str = "1";
                
                callNum.should.be(2);
                
                b.str = "";
                
                callNum.should.be(3);
                
                a.str = "b2";
                
                callNum.should.be(4);
                
                c.str = "b";
                
                callNum.should.be(5);
            });
            
        });
    }
}