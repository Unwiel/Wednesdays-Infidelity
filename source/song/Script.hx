package song;

import flixel.FlxBasic;
import hscript.Interp;
import openfl.Lib;
import hscript.Parser;
import openfl.utils.Assets;

class Script extends FlxBasic
{
	public var interp:Interp;
	public var parser:Parser;

	public override function new()
	{
		super();
		interp = new Interp();
		parser = new Parser();
	}

	public function runScript(script:String)
	{
		try
		{
			interp.execute(parser.parseString(Assets.getText(script)));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");
			
		trace('Script Loaded Succesfully: $script');
		
		executeFunc('create', []);

	}

	public function setVariable(name:String, val:Dynamic):Void
	{
		if (interp == null)
			return;

		try
		{
			interp.variables.set(name, val);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");
	}

	public function getVariable(name:String):Dynamic
	{
		if (interp == null)
			return null;

		try
		{
			return interp.variables.get(name);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");

		return null;
	}
	
	public function existsVariable(name:String):Bool
	{
		if (interp == null)
			return false;

		try
		{
			return interp.variables.exists(name);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");

		return false;
	}

	public function executeFunc(funcName:String, args:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		if (existsVariable(funcName))
		{
			try
			{
				return Reflect.callMethod(null, getVariable(funcName), args);
			}
			catch (e:Dynamic)
				Lib.application.window.alert(e, "Hscript Error!");
		}

		return null;
	}

	override function destroy()
	{
		super.destroy();
		interp = null;
		parser = null;
	}
}
