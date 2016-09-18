package;
import SfTools.*;
import gml.Current;
import gml.Draw;
import gml.draw.*;
import gml.Lib;
import Math.*;
import gml.Mathf.*;
import gml.ds.*;
import gml.d3d.*;
import gml.assets.*;
import gml.input.*;
import gml.input.Window;
import gml.io.IniFile;

class Game {
	/** A bit of magic to hint sections in generated code, since I was unable to rewire
	 *  the compiler to preserve original comments on export (a tricky task). */
	static inline function block(name:String):Bool return raw("true/*{0}*/", name);
	//{ Table constants (replace their uses)
	/** Texture scale */
	static inline var txd:Float = 32;
	/** Table size X */
	static inline var tbx:Float = 128;
	/** Table size Y */
	static inline var tby:Float = 172;
	/** Table height/depth */
	static inline var tbz:Float = 32;
	/** Hole depth */
	static inline var tbh:Float = -32;
	/** Water level */
	static inline var tbWater:Float = -8;
	/** Hole radius */
	static inline var tbr:Float = 20;
	/** Outer padding */
	static inline var tbp:Float = 40;
	/** Central hole extension */
	static inline var tbc:Float = 10;
	/** Table hole detail */
	static inline var tbd:Float = 15;
	/** Background plane extension */
	static inline var tbOuter:Float = 512;
	//}
	//{ Font constants (ditto)
	static inline var fontWidth:Float = 0.5;
	static inline var fontFull:Float = 0.1;
	static inline var fontHalf:Float = fontFull / 2;
	static inline var fontRight:Float = fontWidth - fontFull;
	static inline var fontSpacing:Float = 0.1;
	static inline var fontAdvance:Float = fontWidth + fontSpacing;
	static inline var fontDotAdv:Float = fontFull + fontSpacing;
	//}
	/** Default/reference ball radius*/
	static inline var ballRad:Float = 6;
	/** The videogame */
	static inline function main() {
		var ctx:GameCtxImpl = cast 0;
		var levelModels:GameLevelData<D3dModel>, levelTextures:GameLevelData<Texture>;
		var player:Player, camData:CameraData, waveData:WaveData, conf:GameConf;
		var ball:Ball, ball2:Ball, balls:ArrayList<Ball>;
		var i:Int, k:Int, n:Int, s:String, c1:Color, c2:Color;
		var f:Float, f1:Float, f2:Float;
		var vx:Float, vy:Float, vz:Float, vr:Float;
		var dx:Float, dy:Float, dz:Float, df:Float;
		var x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float;
		var sf:Surface, bk:Background, tx:Texture, md:D3dModel;
		var ww:Int = Window.width, wh:Int = Window.height;
		var osx:Bool = raw("os_type") == raw("os_macosx");
		// The following replace calls to them, substituting arguments accordingly:
		inline function drawRect(x:Float, y:Float, w:Float, h:Float, c:Color = -1, a:Float = 1) {
			Draw.backgroundExt(ctx.white16, x, y, w / 16, h / 16, 0, c, a);
		}
		/** (vx, vy, vz, vr) -> (f1, f2) -> f */
		inline function findAlt() {
			raw('if (true/*"findAlt"*/) {0}', {
			f = 0;
			cfor(f1 = -1, f1 <= 1, f1 += 2, {
				if (dist2d(vx, vy, f1 * (tbx + tbc), 0) < tbr - vr) {
					f = tbh;
					break;
				}
				cfor(f2 = -1, f2 <= 1, f2 += 2, {
					if (dist2d(vx, vy, tbx * f1, tby * f2) < tbr - vr) {
						f = tbh;
						break;
					}
				});
				if (f != 0) break;
			});
			if (f == 0) {
				if (Math.abs(vy) < tbr - vr) {
					if (Math.abs(vx) > tbx + tbc) f = tbz;
				} else if (Math.abs(vx) > tbx - vr || Math.abs(vy) > tby - vr) {
					f = tbz;
				}
			}
			});
		}
		/** */
		inline function addLine2d(x1:Float, y1:Float, x2:Float, y2:Float) {
			md.addVertex(x1, y1, 0);
			md.addVertex(x2, y2, 0);
		}
		/** Adds a point with texture mapping suitable for floors. */
		inline function addPointHor(vx:Float, vy:Float, vz:Float) {
			md.addVertexTexture(vx, vy, vz, (vx + vy) / txd, (vx - vy) / txd);
		}
		/** Adds a point with texture mapping suitable for walls. */
		inline function addPointVert(vx:Float, vy:Float, vz:Float) {
			md.addVertexTexture(vx, vy, vz, 0.25, vz / txd * 4);
		}
		/** Changes: md, x1..z2 */
		inline function addFloor(_x1:Float, _y1:Float, _x2:Float, _y2:Float, _z:Float) {
			x1 = _x1; y1 = _y1; x2 = _x2; y2 = _y2; z1 = _z;
			//
			addPointHor(x1, y1, z1);
			addPointHor(x2, y1, z1);
			addPointHor(x1, y2, z1);
			//
			addPointHor(x2, y1, z1);
			addPointHor(x1, y2, z1);
			addPointHor(x2, y2, z1);
		}
		inline function addWall(_x1:Float, _y1:Float, _z1:Float, _x2:Float, _y2:Float, _z2:Float) {
			x1 = _x1; y1 = _y1; z1 = _z1; x2 = _x2; y2 = _y2; z2 = _z2;
			//
			addPointVert(x1, y1, z1);
			addPointVert(x1, y1, z2);
			addPointVert(x2, y2, z1);
			//
			addPointVert(x2, y2, z1);
			addPointVert(x1, y1, z2);
			addPointVert(x2, y2, z2);
		}
		inline function addFontRect(x:Float, y:Float, w:Float, h:Float) {
			x1 = x; x2 = x1 + w;
			y1 = y; y2 = y1 + h;
			z1 = x1 + (0.5 - y2) * f;
			z2 = x2 + (0.5 - y2) * f;
			x1 += (0.5 - y1) * f;
			x2 += (0.5 - y1) * f;
			//
			md.addVertex(x1, y1, 0);
			md.addVertex(x2, y1, 0);
			md.addVertex(z1, y2, 0);
			//
			md.addVertex(z1, y2, 0);
			md.addVertex(x2, y1, 0);
			md.addVertex(z2, y2, 0);
		}
		inline function addFontTri(u1:Float, v1:Float, u2:Float, v2:Float, u3:Float, v3:Float) {
			y1 = v1; x1 = u1 + (0.5 - y1) * f;
			y2 = v2; x2 = u2 + (0.5 - y2) * f;
			z2 = v3; z1 = u3 + (0.5 - z2) * f;
			//
			md.addVertex(x1, y1, 0);
			md.addVertex(x2, y2, 0);
			md.addVertex(z1, z2, 0);
		}
		//
		if (!ctx.isValid()) {
			ctx = new GameCtxImpl(); // -> #0
			//
			raw("randomize")();
			raw("window_set_caption")("POOL [of doom!] by YellowAfterlife");
			raw("application_surface_enable")(false);
			Display.reset(0, true);
			raw("display_set_windows_alternate_sync")(true);
			raw("draw_set_alpha_test")(true);
			//Window.resize(506, 320);
			Current.frameRate = 60;
			Current.backgroundColor = Color.fromHex(0xBDFFFF);
			D3dContext.enable();
			D3dContext.setCulling(false);
			D3dContext.setHidden(true);
			Window.mouseCursor = WindowCursor.none;
			Window.setMouse(ww / 2, wh / 2);
			//
			IniFile.open("POOL.ini");
			conf = {
				keyUp: IniFile.readInt("controls", "up", KeyCode.W),
				keyDown: IniFile.readInt("controls", "down", KeyCode.S),
				keyLeft: IniFile.readInt("controls", "left", KeyCode.A),
				keyRight: IniFile.readInt("controls", "right", KeyCode.D),
				keyJump: IniFile.readInt("controls", "jump", KeyCode.Space),
				spinX: IniFile.readFloat("controls", "spinX", -0.2),
				spinY: IniFile.readFloat("controls", "spinY", 0.2),
			};
			IniFile.close();
			ctx.conf = conf;
			//
			ctx.menu = true;
			player = { health: 1, rad: 6, alt: 20, ball: null };
			ctx.player = player;
			//
			levelModels = new GameLevelData();
			ctx.levelModels = levelModels;
			levelTextures = new GameLevelData();
			ctx.levelTextures = levelTextures;
			ctx.levelImages = new GameLevelData();
			if (block("Font")) {
				ctx.glyphs = new ArrayList();
				ctx.glyphsRaw = new ArrayList();
				f = 0.125;
				inline function fontCheck(z:String) {
					return gml.NativeString.indexOf(z, s) > 0;
				}
				cfor(k = 0, k < 2, k++, {
					cfor(i = 0, i < 13, i++, {
						s = "0123456789.KO".charAt(i);
						md = new D3dModel();
						md.beginTriangleList();
						if (i == 1) {
							addFontRect(0, 0, fontWidth / 2 + fontHalf, fontFull);
							addFontRect(fontWidth / 2 - fontHalf, fontFull, fontFull, 1 - fontFull * 2);
						}
						if (fontCheck("0235789")) { // top
							addFontRect(0, 0, fontWidth, fontFull);
						}
						if (fontCheck("0123568")) { // bottom
							addFontRect(0, 1 - fontFull, fontWidth, fontFull);
						}
						f1 = fontFull;
						f2 = 0.5 + fontHalf;
						if (fontCheck("K46")) f1 = 0;
						if (fontCheck("045689K")) { // top left
							addFontRect(0, f1, fontFull, f2 - f1);
						}
						if (fontCheck("0234789")) { // top right
							addFontRect(fontWidth - fontFull, f1, fontFull, f2 - f1);
						}
						f1 = 0.5 + fontHalf;
						f2 = 1 - fontFull;
						if (fontCheck("K479")) f2 = 1;
						if (fontCheck("0268K")) { // bottom left
							addFontRect(0, f1, fontFull, f2 - f1);
						}
						if (fontCheck("03456789")) { // bottom right
							addFontRect(fontWidth - fontFull, f1, fontFull, f2 - f1);
						}
						if (fontCheck("23456789K")) { // middle
							f1 = fontFull;
							f2 = fontWidth - fontFull;
							if (fontCheck("2")) f1 = 0;
							if (fontCheck("56")) f2 += fontFull;
							addFontRect(f1, 0.5 - fontHalf, f2 - f1, fontFull);
						}
						if (fontCheck(".")) {
							addFontRect(0, 1 - fontFull, fontFull, fontFull);
						}
						if (fontCheck("K")) {
							addFontRect(fontWidth - fontFull, 0, fontFull, 0.5 - fontHalf);
							addFontRect(fontWidth - fontFull, 0.5 + fontHalf, fontFull, 0.5 - fontHalf);
							addFontTri(fontWidth - fontFull, 0.5 - fontHalf,
								fontWidth, 0.5 - fontHalf,
								fontWidth - fontFull, 0.5 + fontHalf);
							addFontTri(fontWidth - fontHalf, 0.5,
								fontWidth - fontFull, 0.5 + fontHalf,
								fontWidth, 0.5 + fontHalf);
						}
						if (fontCheck("O")) {
							addFontTri(fontFull, 0, 0, fontFull, fontFull, fontFull);
							addFontRect(fontFull, 0, fontWidth - fontFull * 2, fontFull);
							addFontTri(fontRight, 0, fontRight, fontFull, fontWidth, fontFull);
							//
							addFontRect(0, fontFull, fontFull, 1 - fontFull * 2);
							addFontRect(fontRight, fontFull, fontFull, 1 - fontFull * 2);
							//
							addFontTri(0, 1 - fontFull, fontFull, 1 - fontFull, fontFull, 1);
							addFontRect(fontFull, 1 - fontFull, fontWidth - fontFull * 2, fontFull);
							addFontTri(fontRight, 1 - fontFull, fontWidth, 1 - fontFull, fontRight, 1);
						}
						md.endPrimitive();
						if (k > 0) {
							ctx.glyphsRaw[i] = md;
						} else ctx.glyphs[i] = md;
					});
					f = 0;
				});
			}
			if (block("Level textures")) {
				sf = new Surface(16, 16);
				sf.setTarget();
				Draw.clear(-1);
				sf.resetTarget();
				ctx.white16 = sf.toBackground();
				// make textures:
				cfor(i = 0, i < levelTextures.length, i++, {
					inline function cd(v1:Color, v2:Color) {
						c1 = Color.fromHex(v1);
						c2 = Color.fromHex(v2);
					}
					switch (GameLevel.createByIndex(i)) {
						case GameLevel.water: cd(0x478FCF, 0x50A0E7);
						case GameLevel.holes: cd(0x765737, 0x815F3B);
						case GameLevel.walls: cd(0x9F713D, 0xB27E44);
						case GameLevel.table, GameLevel.cover: cd(0x6CB436, 0x79C93D);
					}
					sf.setTarget();
					Draw.clear(c1);
					drawRect(0, 0, 8, 8, c2);
					drawRect(8, 8, 8, 8, c2);
					sf.resetTarget();
					bk = sf.toBackground();
					ctx.levelImages[i] = bk;
					levelTextures[i] = bk.texture;
				});
				sf.destroy();
			}
			if (block("Level models")) {
				cfor(i = 0, i < levelModels.length, i++, {
					md = new D3dModel();
					md.beginTriangleList();
					levelModels[i] = md;
				});
				// outer fill:
				md = new D3dModel();
				md.beginTriangleList();
				cfor (i = -1, i <= 1, i += 2, {
					addFloor((tbx + tbp) * i, -(tby + tbp), (tbx + tbOuter) * i, tby + tbp, tbz);
					addFloor(-(tbx + tbOuter), (tby + tbp) * i, (tbx + tbOuter), (tby + tbOuter) * i, tbz);
				});
				md.endPrimitive();
				ctx.levelOuter = md;
				//
				md = levelModels.table;
				f = 0.001; // have a real small overlap to avoid single pixels on a few spots.
				addFloor(-(tbx - tbr + tbc + f), -tbr, tbx - tbr + tbc + f, tbr, 0);
				cfor(i = -1, i <= 1, i += 2, {
					md = levelModels.table;
					addFloor(-tbx, (tbr - f) * i, tbx, (tby - tbr + f) * i, 0);
					addFloor( -(tbx - tbr + f), tby * i, tbx - tbr + f, (tby - tbr) * i, 0);
					// outer tops:
					md = levelModels.cover;
					addFloor(-(tbx - tbr), tby * i, tbx - tbr, (tby + tbr) * i, tbz);
					addFloor((tbx + tbr + tbc) * i, -tbr * i, (tbx + tbp) * i, tbr * i, tbz);
					addFloor(-(tbx + tbp), (tby + tbr) * i, (tbx + tbp), (tby + tbp) * i, tbz);
					cfor(k = -1, k <= 1, k += 2, {
						addFloor(tbx * i, tbr * k, (tbx + tbr) * i, (tby - tbr) * k, tbz);
						addFloor((tbx + tbr) * i, tbr * k, (tbx + tbp) * i, (tby + tbr) * k, tbz);
					});
				});
				// walls:
				md = levelModels.walls;
				cfor(i = -1, i <= 1, i += 2, {
					cfor(n = -1, n <= 1, n += 2, {
						addWall(tbx * i, tbr * n, 0, tbx * i, (tby - tbr) * n, tbz);
					});
					addWall(-tbx + tbr, tby * i, 0, tbx - tbr, tby * i, tbz);
				});
				// central hole extensions:
				md = levelModels.holes;
				cfor(i = -1, i <= 1, i += 2, {
					cfor(k = -1, k <= 1, k += 2, {
						addWall(tbx * i, tbr * k, 0, (tbx + tbc) * i, tbr * k, tbz);
					});
				});
				// holes:
				cfor(var holeX = -1, holeX <= 1, holeX += 2, {
					cfor(var holeY = -1, holeY <= 1, holeY += 1, {
						if (holeX > 0) {
							f1 = 90 + 90 * Math.max(0, -holeY);
							f2 = 270 - 90 * Math.max(0, holeY);
						} else {
							f1 = -90 + 90 * Math.max(0, holeY);
							f2 = 90 - 90 * Math.max(0, -holeY);
						}
						x1 = tbx * holeX;
						if (holeY == 0) x1 += tbc * holeX;
						y1 = tby * holeY;
						// green part:
						md = ctx.levelModels.table;
						z1 = 0;
						cfor(i = 0, i < 2, i++, {
							cfor(f = f1, f < f2, f += tbd, {
								x2 = ldx(tbr, f);
								y2 = ldy(tbr, f);
								vr = Math.max(Math.abs(x2), Math.abs(y2));
								vx = x1 + x2; vy = y1 + y2;
								addPointHor(vx, vy, z1);
								vx = x1 + x2 / vr * tbr;
								vy = y1 + y2 / vr * tbr;
								addPointHor(vx, vy, z1);
								// last point of first triangle, first point of second triangle:
								x2 = ldx(tbr, f + tbd);
								y2 = ldy(tbr, f + tbd);
								vr = Math.max(Math.abs(x2), Math.abs(y2));
								vx = x1 + x2 / vr * tbr;
								vy = y1 + y2 / vr * tbr;
								cfor(k = 0, k < 2, k++, {
									addPointHor(vx, vy, z1);
								});
								vx = x1 + x2; vy = y1 + y2;
								addPointHor(vx, vy, z1);
								vx = x1 + ldx(tbr, f);
								vy = y1 + ldy(tbr, f);
								addPointHor(vx, vy, z1);
							});
							if (i == 0) {
								f = f1; f1 = f2; f2 = f + 360;
								z1 = tbz;
								md = levelModels.cover;
							}
						});
						// walls:
						md = levelModels.holes;
						z1 = 0; z2 = tbz;
						cfor(i = 0, i < 2, i++, {
							cfor(f = f1, f < f2, f += tbd, {
								vx = x1 + ldx(tbr, f);
								vy = y1 + ldy(tbr, f);
								x2 = x1 + ldx(tbr, f + tbd);
								y2 = y1 + ldy(tbr, f + tbd);
								addPointVert(vx, vy, z1);
								addPointVert(x2, y2, z1);
								addPointVert(vx, vy, z2);
								addPointVert(vx, vy, z2);
								addPointVert(x2, y2, z1);
								addPointVert(x2, y2, z2);
							});
							f1 = 0; f2 = 360;
							z1 = tbh; z2 = 0;
						});
						// bottoms:
						z1 = tbh;
						md = levelModels.holes;
						cfor(i = 0, i < 2, i++, {
							cfor(f = 0, f < 360, f += tbd, {
								vx = x1 + ldx(tbr, f);
								vy = y1 + ldy(tbr, f);
								x2 = x1 + ldx(tbr, f + tbd);
								y2 = y1 + ldy(tbr, f + tbd);
								addPointHor(x1, y1, z1);
								addPointHor(vx, vy, z1);
								addPointHor(x2, y2, z1);
							});
							z1 = tbWater;
							md = levelModels.water;
						});
					});
				});
				//
				cfor(i = 0, i < levelModels.length, i++, {
					levelModels[i].endPrimitive();
				});
			} // level models
			if (block("Cue")) {
				// cue model:
				md = new D3dModel();
				f = 0.05;
				md.addCylinder( -f, -f, 0, f, f, f * 64, 1, 1, true, 8);
				ctx.cueModel = md;
				// cue texture:
				sf = new Surface(4, 64);
				sf.setTarget();
				Draw.clear( -1);
				f1 = 1; f2 = 32;
				drawRect(0, f1, 4, f2, Color.fromHex(0xE7E3BC));
				f1 += f2; f2 = 1;
				drawRect(0, f1, 4, f2, Color.fromHex(0x815F3B));
				f1 += f2; f2 = 32;
				drawRect(0, f1, 4, f2, Color.fromHex(0x765737));
				sf.resetTarget();
				bk = sf.toBackground();
				ctx.cueImage = bk;
				ctx.cueTexture = bk.texture;
				sf.destroy();
			}
			//
			n = 12;
			if (block("Ball shadow")) {
				md = new D3dModel();
				md.addCone( -ballRad, -ballRad, 0, ballRad, ballRad, 0, 1, 1, false, n);
				ctx.ballShadow = md;
			}
			if (block("Ball brow")) {
				md = new D3dModel();
				md.addFloor( -1.1, 0, 0, 1.1, 0.7, 0, 1, 1);
				ctx.ballBrow = md;
			}
			if (block("Ball eye")) {
				md = new D3dModel();
				md.beginTriangleList();
				x1 = 1; y1 = 0;
				cfor(f = 360/12, f <= 360, f += 360/12, {
					x2 = ldx(1, f); y2 = ldy(1, f);
					if (y2 < -0.5) {
						x2 *= y2 / -0.5;
						y2 = -0.5;
					}
					md.addVertex(0, 0, 0);
					md.addVertex(x1, y1, 0);
					md.addVertex(x2, y2, 0);
					x1 = x2; y1 = y2;
				});
				md.endPrimitive();
				ctx.ballEye = md;
			}
			if (block("Ball outer")) {
				sf = new Surface(256, 128);
				md = new D3dModel();
				md.addSphere(0, 0, 0, ballRad, 1, 1, n);
				ctx.ballOuterModel = md;
				//
				sf.setTarget();
				Draw.clearAlpha(0, 0);
				drawRect(0, 24, 256, 128, -1);
				sf.resetTarget();
				bk = sf.toBackground();
				ctx.ballOuterImage = bk;
				ctx.ballOuterTexture = bk.texture;
				sf.destroy();
			}
			if (block("Ball inner")) {
				md = new D3dModel();
				md.beginTriangleList();
				f1 = ballRad * 56 / 100;
				z1 = ballRad * 8 / 10;
				x1 = f1; y1 = 0; z2 = z1;
				cfor(f = 360 / n, f <= 360, f += 360 / n, {
					x2 = ldx(f1, f); y2 = ldy(f1, f);
					md.addVertexTexture(0, 0, ballRad * 0.85, 0.5, 0.5);
					md.addVertexTexture(x1, y1, z1,
						(1 + y1 / f1) / 2 - x1 / f1 / 16, (1 + x1 / f1) / 2);
					md.addVertexTexture(x2, y2, z2,
						(1 + y2 / f1) / 2 - x2 / f1 / 16, (1 + x2 / f1) / 2);
					x1 = x2; y1 = y2;
				});
				md.endPrimitive();
				ctx.ballInnerModel = md;
				//
				ctx.ballInnerTexture = new ArrayList();
				ctx.ballInnerImage = new ArrayList();
				sf = new Surface(128, 128);
				cfor(i = 0, i < 10, i++, {
					sf.setTarget();
					Draw.clearAlpha( -1, 1);
					Draw.color = 0x404040;
					D3dTransform.push();
					D3dTransform.scale(80, 64, 1);
					D3dTransform.translate(64, 64, 0);
					ctx.glyphsRaw[i].draw( -fontWidth / 2, -0.5, 0, Texture.defValue);
					D3dTransform.pop();
					sf.resetTarget();
					bk = sf.toBackground();
					ctx.ballInnerImage[i] = bk;
					ctx.ballInnerTexture[i] = bk.texture;
				});
				sf.destroy();
			}
			if (block("Ball colors")) {
				ctx.ballColors = new ArrayList();
				ctx.ballColors.add(Color.fromHex(0x404040));
				ctx.ballColors.add(Color.fromHex(0xF2DB48));
				ctx.ballColors.add(Color.fromHex(0x50A0E6));
				ctx.ballColors.add(Color.fromHex(0xF9644D));
				ctx.ballColors.add(Color.fromHex(0xBF71F7));
				ctx.ballColors.add(Color.fromHex(0xF49644));
				ctx.ballColors.add(Color.fromHex(0xA3F25E));
				ctx.ballColors.add(Color.fromHex(0xD35F47));
				ctx.ballColors.add(Color.fromHex(0x666F7F));
			}
			ctx.balls = new ArrayList();
			if (block("Minimap")) {
				if (block("Table")) {
					md = new D3dModel();
					md.beginLineList();
					addLine2d( -tbx, -tby, tbx, -tby);
					addLine2d( -tbx, -tby, -tbx, tby);
					addLine2d(tbx, -tby, tbx, tby);
					addLine2d( -tbx, tby, tbx, tby);
					md.endPrimitive();
					ctx.mapTable = md;
				}
				if (block("Player")) {
					md = new D3dModel();
					md.beginLineList();
					addLine2d( -1, -1, 1, 0);
					addLine2d( -1, 1, 1, 0);
					addLine2d( 1, 0, 3, 0);
					addLine2d( -1, -1, -1, 1);
					md.endPrimitive();
					ctx.mapPlayer = md;
				}
				if (block("Ball")) {
					md = new D3dModel();
					md.beginTriangleList();
					md.addCone( -1, -1, 0, 1, 1, 0, 1, 1, false, 12);
					/*md.beginLineList();
					addLine2d( -1, 0, 0, -1);
					addLine2d(0, -1, 1, 0);
					addLine2d(1, 0, 0, 1);
					addLine2d(0, 1, -1, 0);*/
					md.endPrimitive();
					ctx.mapBall = md;
				}
			}
			if (block("Logo")) {
				md = new D3dModel();
				inline function addLogo3(
					u1:Float, v1:Float, u2:Float, v2:Float, u3:Float, v3:Float
				) {
					md.addVertex(u1, v1, 0);
					md.addVertex(u2, v2, 0);
					md.addVertex(u3, v3, 0);
				}
				inline function addLogo4(u1:Float, v1:Float, u2:Float, v2:Float,
				u3:Float, v3:Float, u4:Float, v4:Float) {
					md.addVertex(u1, v1, 0);
					raw("repeat (2) {0}", {
						md.addVertex(u2, v2, 0);
						md.addVertex(u3, v3, 0);
					});
					md.addVertex(u4, v4, 0);
				}
				// https://dl.dropboxusercontent.com/u/3594143/yal.cc/16/09/osg/logo.svg
				// Well, buckle up - logo is done by hand and upside-down, b/c Inkscape.
				md.beginTriangleList();
				// P:
				addLogo4(4, 128, 15, 120, 15, 128, 35, 106); // tail
				addLogo4(15, 120, 35, 106, 15, 0, 35, 60); // left main
				addLogo3(15, 0, 35, 60, 35, 40); // left mid
				addLogo3(15, 0, 35, 40, 35, 15); // left low
				addLogo4(15, 128, 63, 128, 35, 106, 47, 106); // top main
				addLogo4(63, 128, 47, 106, 70, 123, 49, 105); // top corner
				addLogo4(49, 105, 70, 123, 49, 69, 70, 64); // right
				addLogo4(35, 60, 49, 69, 35, 40, 70, 64); // bottom
				// O:
				cfor(i = -1, i <= 1, i += 2, {
					inline function oxt(u) return 128 + (u - 128) * i;
					inline function addLogo4o(u1, v1, u2, v2, u3, v3, u4, v4) {
						addLogo4(128 + (u1 - 128) * i, v1,
							128 + (u2 - 128) * i, v2,
							128 + (u3 - 128) * i, v3,
							128 + (u4 - 128) * i, v4);
					}
					addLogo4o(72, 123, 79, 128, 92, 104, 94, 105); // top left
					addLogo4o(79, 128, 94, 105, 120, 128, 104, 105); // top
					addLogo4o(120, 128, 104, 105, 127, 123, 106, 104); // top right
					addLogo4o(72, 123, 92, 104, 72, 47, 92, 59); // left
					addLogo4o(106, 104, 127, 123, 106, 49, 127, 35); // right
					addLogo4o(92, 59, 72, 47, 106, 49, 107, 20); // bottom
					addLogo3(oxt(106), 49, oxt(107), 20, oxt(127), 35); // corner
				});
				// L:
				addLogo4(190, 128, 186, 125, 218, 128, 207, 120);
				addLogo4(186, 125, 207, 120, 186, 40, 207, 59);
				addLogo4(207, 59, 186, 40, 239, 36, 241, 0);
				addLogo3(239, 36, 241, 37, 241, 0);
				//
				md.endPrimitive();
				ctx.logo = md;
				ctx.logoShadow = Surface.none;
				ctx.logoColor = Surface.none;
			}
			//
			camData = { x1: 200, y1: -200, z1: 150 };
			ctx.cameraData = camData;
			ctx.score = -1;
		} // init
		else { // retrieve
			conf = ctx.conf;
			player = ctx.player;
			levelModels = ctx.levelModels;
			levelTextures = ctx.levelTextures;
			camData = ctx.cameraData;
		}
		waveData = ctx.waveData;
		balls = ctx.balls;
		//{ Keyboard shortcuts
		if (Keyboard.pressed(27)) { // game end
			ctx.balls.destroy();
			ctx.white16.destroy();
			//
			ctx.logo.destroy();
			sf = ctx.logoColor;
			if (Surface.isValid(sf)) sf.destroy();
			sf = ctx.logoShadow;
			if (Surface.isValid(sf)) sf.destroy();
			//
			n = ctx.glyphs.length;
			cfor(i = 0, i < n, i++, {
				ctx.glyphs[i].destroy();
				ctx.glyphsRaw[i].destroy();
			});
			ctx.glyphs.destroy();
			ctx.glyphsRaw.destroy();
			//
			ctx.ballOuterModel.destroy();
			ctx.ballOuterImage.destroy();
			n = ctx.ballInnerImage.length;
			cfor(i = 0, i < n, i++, {
				ctx.ballInnerImage[i].destroy();
			});
			ctx.ballInnerModel.destroy();
			ctx.ballColors.destroy();
			ctx.ballShadow.destroy();
			ctx.ballBrow.destroy();
			ctx.ballEye.destroy();
			//
			n = ctx.levelImages.length;
			cfor(i = 0, i < n, i++, {
				ctx.levelImages[i].destroy();
				ctx.levelModels[i].destroy();
			});
			ctx.levelImages.destroy();
			ctx.levelModels.destroy();
			ctx.levelTextures.destroy();
			//
			ctx.cueImage.destroy();
			ctx.cueModel.destroy();
			//
			ctx.mapTable.destroy();
			ctx.mapPlayer.destroy();
			ctx.mapBall.destroy();
			//
			ctx.destroy();
			//
			raw("game_end")();
			return;
		}
		if (Keyboard.pressed(raw("vk_f5"))) Display.reset(0, true);
		if (Keyboard.pressed(raw("vk_f6")) && Display.aaFlags & 2 != 0) Display.reset(2, true);
		if (Keyboard.pressed(raw("vk_f7")) && Display.aaFlags & 4 != 0) Display.reset(4, true);
		if (Keyboard.pressed(raw("vk_f8")) && Display.aaFlags & 8 != 0) Display.reset(8, true);
		//}
		//{ Step
		var aim:Float = 0;
		var alive = player.health > 0;
		if (ctx.menu) {
			if (Mouse.pressed(MouseButton.LEFT)) {
				ctx.menu = false;
				ctx.score = 0;
				player = { health: 1, healthEase: 1, rad: 6, alt: 20, ball: null };
				player.yaw = dir2d(camData.x1, camData.y1, camData.x2, camData.y2);
				ctx.player = player;
				balls.clear();
				waveData = { };
				ctx.waveData = waveData;
			} else {
				f2 = Lib.getTimer() / 400 + 45;
				f = 0.01;
				camData.z1 = lerp(camData.z1, tbz + 40, f);
				if (camData.z1 > tbz) {
					camData.x1 = lerp(camData.x1, ldx(tbx, f2), f);
					camData.y1 = lerp(camData.y1, ldy(tbx, f2), f);
				}
				camData.x2 = lerp(camData.x2, 0, f);
				camData.y2 = lerp(camData.y2, 0, f);
				camData.z2 = lerp(camData.z2, tbz, f);
			}
		} else
		if (alive) { // in-game
			if (block("Waves")) {
				if (waveData.left > 0) {
					if (waveData.spawn >= 1) {
						waveData.spawn = 0;
						waveData.left -= 1;
						i = waveData.wave;
						vr = ballRad * randomRange(0.8, min(1.7, pow(i, 0.3)));
						ball = {
							x: randomRange( -(tbx - vr), tbx - vr),
							y: randomRange( -(tby - vr), tby - vr),
							z: tbz + 60,
							vz: -8,
							boost: randomRange(0.9, 0.2 + pow(i, 0.4)),
							rush: randomRange(0.9, 0.2 + pow(i, 0.4)),
							number: irandomRange(1, 8),
							rad: vr
						};
						balls.add(ball);
					} else waveData.spawn += 1 / (300 / (10 + waveData.wave));
				} else if (balls.length > 0) {
					// wait
				} else if (waveData.next >= 1) {
					waveData.wave += 1;
					waveData.left = 1 + waveData.wave;
					waveData.next = 0;
				} else {
					waveData.next += 1 / 300;
				}
			}
			if (Window.hasFocus) { // mouselook
				x1 = Window.width >> 1;
				y1 = Window.height >> 1;
				x2 = Window.mouseX - x1;
				y2 = Window.mouseY - y1;
				if (osx) {
					if (Window.fullscreen) {
						Display.setMouse(x1, y1);
					} else Window.setMouse(x1, y1 - (Window.height - Current.height));
				} else Window.setMouse(x1, y1);
				if (osx) y2 += 1;
				x2 *= conf.spinX;
				y2 *= conf.spinY;
				if (player.ease >= 1) {
					player.cueX = lerp(player.cueX, 0, 0.2) + x2 / 180;
					player.cueY = lerp(player.cueY, 0, 0.2) + y2 / 90;
					player.yaw += x2;
					player.tilt += y2;
					player.tilt = clamp(player.tilt, -85, 85);
				}
			}
			if (player.bop > 0) {
				player.bop -= 0.05;
				player.regen = 0;
			} else player.regen = min(player.regen + 1 / 300, 1);
			if (player.health < 1) player.health = min(player.health + player.regen / 600, 1);
			if (block("Attack")) {
				aim = player.cueZ;
				if (Mouse.released(MouseButton.LEFT) && aim > 0.1) {
					f1 = player.yaw;
					f2 = player.tilt;
					dx = ldx(ldx(1, f2), f1);
					dy = ldy(ldx(1, f2), f1);
					dz = ldy(1, f2) / 4;
					// knockback the player:
					df = aim * -0.5;
					player.cx += dx * df;
					player.cy += dy * df;
					player.cz += dz * df;
					// knockback for balls:
					f2 = aim * 6;
					vr = 16;
					vx = player.x + dx * vr;
					vy = player.y + dy * vr;
					vz = player.z + dz * vr;
					vr = 12;
					n = balls.length;
					cfor(i = 0, i < n, i++, {
						ball = balls[i];
						x2 = ball.x - vx;
						y2 = ball.y - vy;
						z2 = ball.z + ballRad - vz;
						f = Math.sqrt(x2 * x2 + y2 * y2 + z2 * z2);
						if (f < vr + ball.rad) {
							df = f2 / (ball.rad / ballRad);
							ball.cx += dx * df;
							ball.cy += dy * df;
							ball.cz = ball.cz / 3 + dz * df;
						}
					});
					aim = lerp(aim, 0, 0.2);
				} else if (Mouse.check(MouseButton.LEFT)) {
					aim = Math.min(aim + 0.05, 1);
				} else aim = lerp(aim, 0, 0.2);
				player.cueZ = aim;
			} // aim
			if (block("XY accel")) {
				vx = player.vx; vy = player.vy;
				x2 = Keyboard.value(conf.keyRight) - Keyboard.value(conf.keyLeft);
				y2 = Keyboard.value(conf.keyUp) - Keyboard.value(conf.keyDown);
				z2 = 0.4 * (1 - aim * 0.4);
				vx += ldx(z2, player.yaw) * y2;
				vy += ldy(z2, player.yaw) * y2;
				vx += ldx(z2, player.yaw - 90) * x2;
				vy += ldy(z2, player.yaw - 90) * x2;
				z2 = Math.sqrt(vx * vx + vy * vy);
				if (z2 > 0) {
					z2 = clamp(z2 - 0.2, 0, 2 * (1 - aim * 0.4)) / z2;
					vx *= z2;
					vy *= z2;
				}
				player.vx = vx; player.vy = vy;
			}
			if (block("Knockback decay")) {
				vx = player.cx;
				vy = player.cy;
				vz = player.cz;
				z2 = Math.sqrt(vx * vx + vy * vy + vz * vz);
				if (z2 > 0) {
					z2 = Math.max(z2 * 0.95 - 0.05, 0) / z2;
					player.cx = vx * z2;
					player.cy = vy * z2;
					player.cz = vz * z2;
				}
			}
			if (block("XY movement")) {
				vr = player.rad;
				vz = player.z;
				vy = player.y;
				//{ X movement
				x1 = player.vx + player.cx;
				vx = player.x + x1;
				findAlt();
				if (vz < f) {
					k = sign(x1);
					cfor(i = Math.floor(Math.abs(x1)), i > 0, i -= 1, {
						vx = player.x + k;
						findAlt();
						if (vz >= f) {
							player.x = vx;
						} else {
							vy += 1;
							findAlt();
							if (vz >= f) {
								player.x = vx;
								player.y = vy;
							} else {
								vy -= 2;
								findAlt();
								if (vz >= f) {
									player.x = vx;
									player.y = vy;
								} else break;
							}
						}
					});
					player.vx = 0;
					player.cx *= -0.5;
				} else player.x = vx;
				//}
				//{ Y movement
				y1 = player.vy + player.cy;
				vx = player.x;
				vy = player.y + y1;
				findAlt();
				if (vz < f) {
					k = sign(y1);
					cfor(i = Math.floor(Math.abs(y1)), i > 0, i -= 1, {
						vy = player.y + k;
						findAlt();
						if (vz >= f) {
							player.y = vy;
						} else {
							vx += 1;
							findAlt();
							if (vz >= f) {
								player.y = vy;
								player.x = vx;
							} else {
								vx -= 2;
								findAlt();
								if (vz >= f) {
									player.y = vy;
									player.x = vx;
								} else break;
							}
						}
					});
					player.vy = 0;
					player.cy *= -0.5;
				} else player.y = vy;
				//}
			}
			if (block("Z axis")) {
				vx = player.x;
				vy = player.y;
				vz = player.z;
				vr = player.rad;
				findAlt();
				if (vz > f) {
					player.vz -= raw("1 / 24");
				} else player.jump = 8;
				if (player.jump > 0) {
					if (Keyboard.check(conf.keyJump)) {
						player.vz = 1.1;
						player.jump = 0;
					} else player.jump -= 1;
				}
				//
				z1 = player.vz + player.cz;
				player.z += z1;
				if (z1 < 0 && player.z <= f) {
					player.z = f;
					player.vz = 0;
					player.cz = 0;
				}
				if (player.z + player.alt * 0.5 <= tbWater) {
					player.health = 0;
				}
			}
			if (player.health > 0) {
				player.healthEase += clamp(player.health - player.healthEase, -0.001, 0.001);
				player.healthEase = lerp(player.healthEase, player.health, 0.1);
			}
			if (player.health > 0 && block("Camera")) {
				x1 = player.x;
				y1 = player.y;
				z1 = player.z + player.alt * 0.7;
				x2 = x1 + ldx(ldx(1, player.tilt), player.yaw);
				y2 = y1 + ldy(ldx(1, player.tilt), player.yaw);
				z2 = z1 + ldy(1, player.tilt);
				//
				if (player.ease < 1) {
					f = player.ease;
					player.ease = f + 1 / 50;
					f = f / 3;
				} else f = 1;
				//
				camData.x1 = lerp(camData.x1, x1, f);
				camData.y1 = lerp(camData.y1, y1, f);
				camData.z1 = lerp(camData.z1, z1, f);
				camData.x2 = lerp(camData.x2, x2, f);
				camData.y2 = lerp(camData.y2, y2, f);
				camData.z2 = lerp(camData.z2, z2, f);
			}
		} else { // dead
			player.ease = max(player.ease - 1/25, 0);
			camData.z2 += 0.003;
			//camData.z1 += 0.001;
		}
		//}
		//{ Draw
		D3dContext.setProjectionExt(
			camData.x1, camData.y1, camData.z1,
			camData.x2, camData.y2, camData.z2,
			0, 0, 1, 75, ww / wh, 0.1, 640);
		if (block("Balls")) {
			n = balls.length;
			cfor(i = 0, i < n, i++, {
				ball = balls[i];
				vr = ball.rad;
				//
				f = dir2d(ball.x, ball.y, player.x, player.y);
				ball.yaw -= clamp(raw("angle_difference")(ball.yaw, f), -3, 3);
				//{ Knockback friction
				dx = ball.cx; dy = ball.cy;
				df = Math.sqrt(dx * dx + dy * dy);
				if (df > 0) {
					df = Math.max(df * 0.99 - 0.05, 0) / df;
					dx *= df;
					dy *= df;
				}
				if (df < 0.16 && ball.z <= ball.gz) ball.bounces = 0;
				//}
				if (dx != 0 || dy != 0) { // Knockback handling
					x1 = ball.x; y1 = ball.y;
					if (x1 > -tbx && x1 < tbx && y1 > -tby && y1 < tby) {
						z1 = 0.5;
					} else z1 = 0.2;
					vx = x1 + dx; vy = y1 + dy; vz = ball.z;
					findAlt();
					if (vz < f) {
						vx -= dx;
						findAlt();
						if (vz < f) {
							vx += dx;
							vy -= dy;
							findAlt();
							if (vz < f) {
								vx -= dx;
								dx *= -z1;
							} else ball.x = vx;
							dy *= -z1;
						} else {
							dx *= -z1;
							ball.y = vy;
						}
					} else {
						ball.x = vx;
						ball.y = vy;
					}
					ball.cx = dx; ball.cy = dy;
					// Knock:
					vx = ball.x; vy = ball.y;
					cfor(k = 0, k < n, k++, if (k != i) {
						ball2 = balls[k];
						if (ball2.col) continue;
						x2 = ball2.x - vx;
						y2 = ball2.y - vy;
						z2 = ball2.z - vz;
						f1 = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
						f2 = ball2.rad;
						if (f1 < vr + f2) {
							x1 = (ball.cx * (vr - f2) + (2 * f2 * ball2.cx)) / (vr + f2);
							x2 = (ball2.cx * (f2 - vr) + (2 * vr * ball.cx)) / (vr + f2);
							y1 = (ball.cy * (vr - f2) + (2 * f2 * ball2.cy)) / (vr + f2);
							y2 = (ball2.cy * (f2 - vr) + (2 * vr * ball.cy)) / (vr + f2);
							z1 = (ball.cz * (vr - f2) + (2 * f2 * ball2.cz)) / (vr + f2);
							z2 = (ball2.cz * (f2 - vr) + (2 * vr * ball.cz)) / (vr + f2);
							//
							ball.cx = x1; ball.cy = y1; ball.cz = z1; ball.col = true;
							ball2.cx = x2; ball2.cy = y2; ball2.cz = z2; ball2.col = true;
							ball.bounces += 1;
							ball2.bounces += 1;
						}
					});
				}
				//{ Jump
				dx = ball.cx;
				dy = ball.cy;
				df = ball.jump;
				if (df > 0 && df < 1) {
					f1 = Math.sin(df * Math.PI) * ball.boost;
					vx = ball.x + ldx(f1, ball.yaw);
					vy = ball.y + ldy(f1, ball.yaw);
					vz = ball.z;
					findAlt();
					if (vz >= f) {
						f1 = 5;
						dx += (vx - ball.x) * f1;
						dy += (vy - ball.y) * f1;
						//
						ball.x = vx;
						ball.y = vy;
						ball.jump = df + 0.03;
					} else ball.jump = 1;
				}
				//}
				if ((dx != 0 || dy != 0) && player.bop <= 0) { // Bop (dx, dy)
					vx = dx; vy = dy;
					dx = player.x - ball.x;
					dy = player.y - ball.y;
					dz = clamp(ball.z, player.z + player.rad,
						player.z + player.alt - player.rad) - ball.z;
					df = sqrt(dx * dx + dy * dy + dz * dz);
					if (df < ball.rad + player.rad) {
						player.bop = 1;
						df = sqrt(ball.rad / ballRad) / pow(ball.boost, 0.8);
						player.cx += vx * df;
						player.cy += vy * df;
						player.cz = min(player.cz + 1, 2);
						player.health -= df / 7;
						if (player.health <= 0) {
							player.healthEase = 0;
							camData.z2 -= player.alt * 0.2;
							camData.z1 -= player.alt * 0.2;
							player.alt *= 0.6;
						} else player.regen = 0;
						player.ball = ball;
					}
				}
				//{ Push
				x1 = ball.x; y1 = ball.y; z1 = ball.z;
				cfor(k = 0, k < n, k++, if (i != k) {
					ball2 = balls[k];
					x2 = ball2.x - x1;
					y2 = ball2.y - y1;
					z2 = ball2.z - z1;
					f2 = vr + ball2.rad;
					f = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
					if (f < f2) {
						while (f == 0) {
							x2 = randomRange( -1, 1);
							y2 = randomRange( -1, 1);
							f = sqrt(x2 * x2 + y2 * y2);
						}
						f = (f2 - f) / f / 10;
						x2 *= f;
						y2 *= f;
						//{ Move ball 1
						vx = x1 - x2;
						vy = y1 - y2;
						vz = ball.z;
						findAlt();
						if (vz >= f) {
							ball.x = vx; x1 = vx;
							ball.y = vy; y1 = vy;
						}
						//}
						//{ Move ball 2
						vx = ball2.x + x2;
						vy = ball2.y + y2;
						vz = ball2.z;
						vr = ball2.rad;
						findAlt();
						if (vz >= f) { ball2.x = vx; ball2.y = vy; }
						vr = ball.rad;
						//}
					}
				});
				//}
				if (block("Push away from player")) {
					vx = ball.x; vy = ball.y; vz = ball.z;
					x2 = player.x - vx;
					y2 = player.y - vy;
					z2 = clamp(ball.z, player.z + player.rad,
						player.z + player.alt - player.rad) - vz;
					f2 = player.rad + vr;
					f = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
					if (f < f2) {
						while (f == 0) {
							x2 = randomRange( -1, 1);
							y2 = randomRange( -1, 1);
							f = sqrt(x2 * x2 + y2 * y2);
						}
						f = (f2 - f) / f / 10;
						x2 *= f;
						y2 *= f;
						vx = x1 - x2;
						vy = y1 - y2;
						findAlt();
						if (vz >= f) {
							ball.x = vx;
							ball.y = vy;
						}
					}
				}
				//{ Z accel
				vx = ball.x; vy = ball.y; vz = ball.z;
				findAlt();
				ball.gz = f;
				if (vz > f) {
					ball.vz -= 1 / 24;
				} else {
					ball.wait -= (1 / 30) * ball.rush;
					if (ball.wait <= 0) {
						ball.wait = 1;
						if (alive || dist2d(vx, vy, player.x, player.y) > 32) {
							ball.jump = 0.001;
						}
						ball.vz = 0.9;
					}
				}
				//}
				//{ Z movement
				dz = ball.vz + ball.cz;
				if (dz != 0) {
					vz += dz;
					if (dz < 0 && vz <= f) {
						ball.z = f;
						ball.vz = 0;
						ball.cz = abs(ball.cz) * 0.7;
						if (ball.cz < 0.1) ball.cz = 0;
					} else ball.z = vz;
					if (ball.z + ball.rad * 2 < tbWater) {
						k = 1 + ball.bounces;
						if (k > 3) k = 3;
						ctx.score += k;
						if (player.ball == ball) player.ball = null;
						balls.delete(i);
						i -= 1; n -= 1;
					}
				}
				//}
			}); // for (balls)
			cfor(i = 0, i < n, i++, { // clear col
				ball = balls[i];
				ball.col = false;
			});
		}
		if (alive && player.health <= 0) { // KO'd
			ctx.koSlideIn = 0;
			ctx.koSlideOut = 0;
			ctx.koSlideThru = 0;
		}
		Texture.setInterpolation(false);
		Texture.setRepeat(true);
		Draw.color = -1;
		if (block("Environment")) {
			Draw.color = Current.backgroundColor;
			ctx.levelOuter.draw(0, 0, 0, Texture.defValue);
			Draw.color = -1;
			//
			cfor(i = 0, i < levelModels.length, i++, {
				switch (GameLevel.createByIndex(i)) {
					case GameLevel.cover: if (camData.z1 < tbz) continue;
					case GameLevel.table: if (camData.z1 < 0) continue;
					default:
				}
				levelModels[i].draw(0, 0, 0, levelTextures[i]);
			});
			//
		}
		if (block("Balls")) {
			n = balls.length;
			if (block("Shadows")) {
				md = ctx.ballShadow;
				Draw.color = 0;
				Draw.alpha = 0.4;
				D3dContext.setCulling(true);
				cfor(i = 0, i < n, i++, {
					ball = balls[i];
					if (ball.gz > tbWater) {
						D3dTransform.push();
						f = ball.rad / ballRad * (40 / (40 + ball.z));
						D3dTransform.scaleSame(f);
						D3dTransform.rotateZ(0);
						D3dTransform.translate(ball.x, ball.y, ball.gz + 0.04);
						md.draw(0, 0, 0, Texture.none);
						D3dTransform.pop();
					}
				});
				D3dContext.setCulling(false);
				Draw.color = -1;
				Draw.alpha = 1;
			}
			var pq = new PriorityQueue<Ball>();
			x1 = camData.x1; y1 = camData.y1; z1 = camData.z1;
			cfor(i = 0, i < n, i++, {
				ball = balls[i];
				pq.add(ball, sqr(ball.x - x1) + sqr(ball.y - y1) + sqr(ball.z - z1));
			});
			cfor(i = 0, i < n, i++, { // ball multipass
				ball = pq.deleteMax();
				if (osx && ball.z + ball.rad <= 0) continue;
				f1 = ball.jump;
				c1 = ctx.ballColors[ball.number];
				c2 = Color.merge(c1, 0, 0.7);
				cfor(k = 0, k < 6, k++, {
					D3dTransform.push();
					switch (k) { // pass
						case 0: { // Inner
							md = ctx.ballInnerModel;
							tx = ctx.ballInnerTexture[ball.number];
							Draw.color = -1;
						};
						case 1: { // Outer
							md = ctx.ballOuterModel;
							tx = ctx.ballOuterTexture;
							Draw.color = c1;
						};
						case 2, 3: { // Eyes
							md = ctx.ballEye;
							tx = Texture.none;
							f = (k - 2.5) * 2;
							D3dTransform.rotateZ(-90 - f * 10);
							D3dTransform.rotateY(90);
							D3dTransform.translate(ballRad, f * 0.5, 0);
							D3dTransform.rotateZ(f * 30);
							Draw.color = c2;
						};
						case 4, 5: { // Brows
							md = ctx.ballBrow;
							tx = Texture.none;
							f = (k - 4.5) * 2;
							D3dTransform.translate(0, -1.7, 0);
							D3dTransform.rotateZ(-90 - f * 5);
							D3dTransform.rotateY(90);
							D3dTransform.translate(ballRad, f * 0.5, 0);
							D3dTransform.rotateY(random(10));
							D3dTransform.rotateZ(f * 30);
							Draw.color = c2;
						};
						default: { md = null; tx = null; };
					}
					f = ball.rad / ballRad;
					D3dTransform.scaleSame(f);
					f = 0 + sin(f1 * PI) * 7 - dir2d(0, ball.z,
						dist2d(ball.x, ball.y, player.x, player.y), player.z + player.alt * 0.6);
					D3dTransform.rotateY(f);
					D3dTransform.rotateZ(ball.yaw);
					D3dTransform.translate(ball.x, ball.y, ball.z + ball.rad);
					md.draw(0, 0, 0, tx);
					D3dTransform.pop();
				});
			});
			pq.destroy();
			Draw.color = -1;
		}
		if (!ctx.menu && player.health > 0 && player.ease >= 0.7 && block("Cue")) {
			D3dTransform.push();
			D3dTransform.translate(1 - player.cueY, 1.4 + player.cueX,
				//1 * (1 - aim * .9) - player.cueY * (1 - aim * .5),
				//1.4 * (1 - aim * .9) + player.cueX * (1 - aim * .5),
				-Math.pow(player.cueZ, 1.5));
			D3dTransform.rotateY(-player.tilt - 90);
			D3dTransform.rotateZ(player.yaw);
			D3dTransform.translate(player.x, player.y, player.z + player.alt * 0.7);
			ctx.cueModel.draw(0, 0, 0, ctx.cueTexture);
			D3dTransform.pop();
		}
		if (block("UI")) { // UI
			D3dContext.setProjectionOrtho(0, 0, ww, wh, 0);
			df = Math.ceil(wh / 16 / 8) * 8;
			if (ctx.score > 0 && block("Score")) {
				s = Std.string(ctx.score);
				n = s.length;
				D3dTransform.push();
				D3dTransform.scaleSame(df);
				D3dTransform.translate(df / 4, df / 8, 0);
				f = 0;
				cfor(i = 0, i < n, i++, {
					md = ctx.glyphs[s.charCodeAt(i) - "0".code];
					Draw.color = 0; Draw.alpha = 0.5;
					md.draw(f + fontHalf, fontHalf, 0, Texture.none);
					Draw.color = -1; Draw.alpha = 1;
					md.draw(f, 0, 0, Texture.none);
					f += fontAdvance;
				});
				D3dTransform.pop();
			}
			if (block("Health")) {
				md = new D3dModel();
				md.beginTriangleList();
				f = 0.125; vx = 3; vy = 1;
				cfor(i = 0, i < 2, i++, {
					addFontRect( -vx, (vy - fontFull) * i, vx, fontFull);
					addFontRect(-fontFull - (vx - fontFull) * i, fontFull, fontFull, vy - fontFull * 2);
				});
				vz = (vx - fontFull * 2) * clamp(player.healthEase, 0, 1);
				addFontRect( -vx + fontFull, fontFull, vz, (vy - fontFull * 2));
				md.endPrimitive();
				D3dTransform.push();
				D3dTransform.scaleSame(df);
				D3dTransform.translate(ww - df / 4,
					df / 8 - sqr(1 - player.ease) * df * 1.5, 0);
				Draw.color = 0; Draw.alpha = 0.5;
				md.draw(fontHalf, fontHalf, 0, Texture.none);
				Draw.color = -1; Draw.alpha = 1;
				md.draw(0, 0, 0, Texture.none);
				D3dTransform.pop();
				md.destroy();
			}
			if (ctx.menu) {
				ctx.logoEase = min(ctx.logoEase + 1/50, 1);
			} else ctx.logoEase = max(ctx.logoEase - 0.1, 0);
			if (ctx.logoEase > 0) { // POOL
				cfor(k = 0, k < 2, k++, { // Color->Shadow->Combine
					if (k != 0) {
						sf = ctx.logoShadow;
						Draw.color = 0;
					} else {
						Draw.color = -1;
						sf = ctx.logoColor;
					}
					if (!Surface.isValid(sf) || sf.width != ww || sf.height != wh) {
						if (Surface.isValid(sf)) sf.destroy();
						sf = new Surface(ww, wh);
						if (k != 0) {
							ctx.logoShadow = sf;
						} else ctx.logoColor = sf;
					}
					sf.setTarget();
					D3dContext.setProjectionOrtho(0, 0, ww, wh, 0);
					Draw.clearAlpha(0, 0);
					i = k != 0 ? 1 : 0;
					while (i >= 0) {
						D3dTransform.push();
						f = min(ww, wh) / 2 / 128;
						f *= 1 + i / 32;
						D3dTransform.scale(f, -f, 1);
						D3dTransform.translate(ww / 2, wh / 2, 0);
						ctx.logo.draw( -128, -64, 0, Texture.none);
						D3dTransform.pop();
						i -= 2;
					}
					if (k == 1) {
						Draw.setBlendMode(BlendMode.Sub);
						drawRect(0, 0, ww, wh, 0, 0.5);
						Draw.setBlendMode(BlendMode.Add);
						Draw.surface(ctx.logoColor, 0, 0);
						Draw.setBlendMode(BlendMode.Normal);
					}
					sf.resetTarget();
				});
				D3dContext.setProjectionOrtho(0, 0, ww, wh, 0);
				f = pow(ctx.logoEase, 2);
				Draw.surfaceExt(ctx.logoShadow, 0, 0, 1, 1, 0, -1, 0.9 * f);
			}
			if (!ctx.menu) { // ingame
				if (block("Minimap")) {
					vz = (wh / 8) / tby;
					vx = tby * vz + 8;
					vy = wh - tby * vz - 8 + (tby * 2 + 16) * sqr(1 - player.ease);
					vr = 0;
					drawRect(vx - tbx * vz, vy - tby * vz, tbx * 2 * vz, tby * 2 * vz, 0, 0.5);
					if (block("Balls")) {
						n = balls.length;
						cfor(i = 0, i < n, i++, {
							ball = balls[i];
							x1 = ball.x; y1 = ball.y;
							if (x1 < -tbx || x1 > tbx || y1 < -tby || y1 > tby) continue;
							Draw.color = ctx.ballColors[ball.number];
							D3dTransform.push();
							f = ball.rad; D3dTransform.scaleSame(f);
							D3dTransform.translate(x1, y1, 0);
							D3dTransform.scaleSame(vz);
							D3dTransform.rotateZ(vr);
							D3dTransform.translate(vx, vy, 0);
							ctx.mapBall.draw(0, 0, 0, Texture.none);
							D3dTransform.pop();
						});
					}
					if (block("Table")) {
						D3dTransform.push();
						D3dTransform.scaleSame(vz);
						D3dTransform.rotateZ(vr);
						D3dTransform.translate(vx, vy, 0);
						Draw.color = -1;
						ctx.mapTable.draw(0, 0, 0, Texture.none);
						D3dTransform.pop();
					}
					if (block("Player")) {
						D3dTransform.push();
						f = player.rad;
						D3dTransform.scaleSame(f);
						D3dTransform.rotateZ(player.yaw);
						D3dTransform.translate(player.x, player.y, 0);
						D3dTransform.scaleSame(vz);
						D3dTransform.rotateZ(vr);
						D3dTransform.translate(vx, vy, 0);
						Draw.color = -1;
						ctx.mapPlayer.draw(0, 0, 0, Texture.none);
						D3dTransform.pop();
					}
				}
				if (player.health > 0) { // crosshair
					x1 = ww / 2; y1 = wh / 2;
					drawRect(x1 - 1, y1 - 1, 2, 2, -1, 0.5);
					if (aim > 0) {
						drawRect(x1 + 8, y1 - 1, aim * 16, 2, -1, 0.5);
						drawRect(x1 - 8, y1 - 1, aim * -16, 2, -1, 0.5);
						drawRect(x1 - 1, y1 + 8, 2, aim * 16, -1, 0.5);
						drawRect(x1 - 1, y1 - 8, 2, aim * -16, -1, 0.5);
					}
				} // crosshair
				else { // KO
					vz = wh / 4;
					f = ctx.koSlideIn;
					x1 = 0.45; x2 = 0.55;
					//vx = lerp( -1.3, 1.3, f);
					//ctx.koSlideIn += (1.001 - Math.pow(Math.sin(f), 2)) * 0.01;
					if (f < 1) {
						vx = lerp(-0.3, x1, pow(f, 2));
						ctx.koSlideIn = f + 1 / 30;
					} else {
						f = ctx.koSlideThru;
						if (f < 1) {
							vx = lerp(x1, x2, f);
							ctx.koSlideThru = f + 1 / 180;
						} else {
							f = ctx.koSlideOut;
							if (f < 1) {
								vx = lerp(x2, 1.3, 1 - pow(1 - f, 2));
								ctx.koSlideOut = f + 1 / 20;
							} else vx = 2;
						}
						ball = player.ball;
						if (ball != null) {
							f = 0.01;
							camData.x2 = lerp(camData.x2, ball.x, f);
							camData.y2 = lerp(camData.y2, ball.y, f);
							camData.z2 = lerp(camData.z2, ball.z + ballRad, f);
						}
						if (Mouse.pressed(MouseButton.LEFT)) {
							ctx.menu = true;
						}
					}
					D3dTransform.push();
					D3dTransform.scaleSame(vz);
					D3dTransform.translate(vx * ww, (wh - vz) / 2, 0);
					cfor(i = 0, i < 2, i++, {
						f = -(fontAdvance * 2 + fontDotAdv + fontFull) / 2;
						vy = 0;
						if (i == 0) {
							Draw.color = 0; 
							Draw.alpha = 1;
							vy += 2 / vz;
							f += vy;
						} else {
							Draw.color = -1;
							Draw.alpha = 1;
						}
						ctx.glyphs[11].draw(f, vy, 0, Texture.none); // K
						f += fontAdvance;
						ctx.glyphs[10].draw(f, vy, 0, Texture.none); // .
						f += fontDotAdv;
						ctx.glyphs[12].draw(f, vy, 0, Texture.none); // O
						f += fontAdvance;
						ctx.glyphs[10].draw(f, vy, 0, Texture.none); // .
					});
					D3dTransform.pop();
				} // KO
			}
		}
		//}
	}
}

@:doc @:nativeGen typedef Player = {
	health:Float, // Actual health (0..1)
	?healthEase:Float, // Displayed health (eased to match actual health).
	?regen:Float, // Regeneration speed multiplier (0..1).
	?jump:Float, // Countdown for whether the player still can jump.
	?x:Float, ?y:Float, ?z:Float, // Position
	?vx:Float, ?vy:Float, ?vz:Float, // Velocity (walk/jump)
	?cx:Float, ?cy:Float, ?cz:Float, // Knockback velocity
	rad:Float, alt:Float, // Radius, Z height
	ball:Ball, // A reference to last ball that bopped the player
	?bop:Float, // Player can only be bopped so often (bop "cooldown").
	?cueX:Float, ?cueY:Float, ?cueZ:Float, // Cue offset (easing when rotating the view).
	?yaw:Float, ?tilt:Float, // Camera Z and Y axis rotation.
	?ease:Float, // Ease-in/ease-out for UI.
}
@:doc @:nativeGen typedef Ball = {
	?x:Float, ?y:Float, ?z:Float, // Position
	?cx:Float, ?cy:Float, ?cz:Float, // Knockback velocity
	?vz:Float, // Vertical velocity (jumping)
	?col:Bool, // Whether this ball partaked in a ball-ball collision this frame already.
	?bounces:Int, // Counts up ball-ball richochets for combos. Reset on speed loss.
	?gz:Float, // Memorized ground' Z (for drawing shadow correctly)
	?yaw:Float, // Z-axis rotation.
	?jump:Float, // Jump progress (0..1).
	?wait:Float, // Waiting time until next jump (0..1).
	boost:Float, // Multiplier for jump XY velocity.
	rush:Float, // Divisor for waiting times.
	number:Int, // Determines number and color of this ball.
	rad:Float, // Perceived and used radius.
}
/** Stores camera positions for easing. */
@:doc @:nativeGen typedef CameraData = {
	?x1:Float, ?y1:Float, ?z1:Float, ?x2:Float, ?y2:Float, ?z2:Float
}
/** Stores information about the ongoing wave spawning. */
@:doc @:nativeGen typedef WaveData = {
	?wave:Int, ?left:Int, ?spawn:Float, ?next:Float, 
}
/** Reflects the customizeable INI config file */
@:doc @:nativeGen typedef GameConf = {
	?keyUp:Int,
	?keyDown:Int,
	?keyLeft:Int,
	?keyRight:Int,
	?keyJump:Int,
	?spinX:Float,
	?spinY:Float,
}

/** Quirky structure for accessing the list of game's models/textures*/
@:build(ArrayObject.build(GameLevel)) abstract GameLevelData<T>(ArrayList<T>) {
	//
	public var holes:T;
	public var water:T;
	public var table:T;
	public var walls:T;
	public var cover:T;
	//
	private static var sizeof:Int;
	public var length(get, never):Int;
	private inline function get_length():Int return sizeof;
	//
	public inline function new() this = SfTools.raw("ds_list_create")();
	public inline function destroy() this.destroy();
	//
	public inline function get(i:GameLevel):T return this[i.getIndex()];
	public inline function set(i:GameLevel, v:T):Void this[i.getIndex()] = v;
	//
	@:arrayAccess public inline function getAt(i:Int):T return this[i];
	public inline function setAt(i:Int, v:T):Void this[i] = v;
	@:arrayAccess private inline function __arrayWrite(i:Int, v:T):T { setAt(i, v); return v; }
}
@:doc @:nativeGen @:build(ArrayObject.build(GameLevelData)) enum GameLevel { }

/** Generates a GML enum with all game's persistent variables. */
@:build(ArrayObject.build(GameCtx)) abstract GameCtxImpl(Grid<Dynamic>) {
	public var conf:GameConf;
	public var menu:Bool;
	public var player:Player;
	public var balls:ArrayList<Ball>;
	public var score:Int;
	public var waveData:WaveData;
	public var cameraData:CameraData;
	//
	public var white16:Background;
	public var logo:D3dModel;
	public var logoColor:Surface;
	public var logoShadow:Surface;
	public var logoEase:Float;
	//
	/** Contains models for used glyphs, "0123456789.KO" */
	public var glyphs:ArrayList<D3dModel>;
	/** Same as "glyphs" but without a baked-in shear */
	public var glyphsRaw:ArrayList<D3dModel>;
	//
	/** Model for the colored bits of balls. Just a sphere. */
	public var ballOuterModel:D3dModel;
	/** Texture for the colored bits of balls. Has a cutout on top. */
	public var ballOuterTexture:Texture;
	public var ballOuterImage:Background;
	/** Model for the number area of balls. A flattened cone with pre-skewed UVs. */
	public var ballInnerModel:D3dModel;
	/** Textures for ball numbers (non-skewed glyphs) */
	public var ballInnerTexture:ArrayList<Texture>;
	public var ballInnerImage:ArrayList<Background>;
	/** An array of ball colors per number (follows a common pool color scheme). */
	public var ballColors:ArrayList<Color>;
	/** A flat model for ball shadows. Same LOD as ball itself. */
	public var ballShadow:D3dModel;
	/** A custom model for "eye" areas of balls. Circle-ish. */
	public var ballEye:D3dModel;
	/** A custom model for ball' brows. Rectangular. */
	public var ballBrow:D3dModel;
	//
	public var levelTextures:GameLevelData<Texture>;
	public var levelImages:GameLevelData<Background>;
	public var levelModels:GameLevelData<D3dModel>;
	/** A single-color primitive that covers the plateu outside the game area. */
	public var levelOuter:D3dModel;
	//
	public var cueModel:D3dModel;
	public var cueTexture:Texture;
	public var cueImage:Background;
	//
	/** Minimap' outer edge. */
	public var mapTable:D3dModel;
	/** Minimap' player symbol. */
	public var mapPlayer:D3dModel;
	/** Minimap' ball symbol. */
	public var mapBall:D3dModel;
	// "K.O." easing variables:
	public var koSlideIn:Float;
	public var koSlideOut:Float;
	public var koSlideThru:Float;
	//
	private static var sizeof:Int;
	public inline function new() this = new Grid(sizeof, 1);
	public inline function destroy() this.destroy();
	public inline function isValid() return Grid.isValid(this);
	private inline function get(i:GameCtx):Dynamic {
		return this.get(i.getIndex(), 0);
	}
	private inline function set(i:GameCtx, v:Dynamic):Void {
		this.set(i.getIndex(), 0, v);
	}
}
@:doc @:nativeGen @:build(ArrayObject.build(GameCtxImpl)) enum GameCtx { }
