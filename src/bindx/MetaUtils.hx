package bindx;

#if macro
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;
using Lambda;

class MetaUtils {

	static public inline var BINDABLE_META = ":bindable";

	static public function findParam(meta:MetadataEntry, name:String):Expr {
        if (meta.params == null) {
            return null;
        }
        for (p in meta.params) {
            switch (p.expr) {
                case EBinop(OpAssign, e1, e2):
                    if (e1.toString() == name) return {expr:e2.expr, pos:p.pos};
                case _:
                    Context.warning('Bindable arguments syntax error. Supported syntax: (flag1=true, flag2=false)', p.pos);
            }
        }
        return null;
    }

    static public inline function bindableMeta(meta:Metadata):MetadataEntry
        return meta.find(function (it) return it.name == BINDABLE_META);
}

class FieldMetaUtils {
	static public inline function bindableMeta(field:Field):MetadataEntry
        return MetaUtils.bindableMeta(field.meta);

    static public inline function hasBindableMeta(field:Field):Bool
    	return bindableMeta(field) != null;
}

class ClassFieldMetaUtils {
	static public inline function bindableMeta(field:ClassField):MetadataEntry
        return MetaUtils.bindableMeta(field.meta.get());

    static public inline function hasBindableMeta(field:ClassField):Bool
    	return bindableMeta(field) != null;
}

class ClassTypeMetaUtils {
	static public inline function bindableMeta(classType:ClassType):MetadataEntry
        return MetaUtils.bindableMeta(classType.meta.get());

    static public inline function hasBindableMeta(classType:ClassType):Bool
    	return bindableMeta(classType) != null;
}

class ExprMetaUtils {
	static public inline function isTrue(expr:Expr):Bool
		return expr.expr.match(EConst(CIdent("true")));

	static public inline function isFalse(expr:Expr):Bool
		return expr.expr.match(EConst(CIdent("false")));

	static public inline function isNotNullAndTrue(expr:Expr):Bool
		return expr != null && isTrue(expr);

	static public inline function isNullOrTrue(expr:Expr):Bool
		return expr == null || isTrue(expr);
}

#end