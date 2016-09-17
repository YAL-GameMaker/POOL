// Generated at 2016-09-17 18:34:19 (1187ms)
enum Player { health, healthEase, regen, jump, x, y, z, vx, vy, vz, cx, cy, cz, rad, alt, ball, bop, cueX, cueY, cueZ, yaw, tilt, ease }
enum Ball { x, y, z, cx, cy, cz, vz, col, bounces, gz, yaw, jump, wait, boost, rush, number, rad }
enum CameraData { x1, y1, z1, x2, y2, z2 }
enum WaveData { wave, left, spawn, next }
enum GameLevel { water, holes, walls, cover }
enum GameCtx { menu, player, balls, score, waveData, cameraData, white16, logo, logoColor, logoShadow, logoEase, glyphs, glyphsRaw, ballOuterModel, ballOuterTexture, ballOuterImage, ballInnerModel, ballInnerTexture, ballInnerImage, ballColors, ballShadow, ballEye, ballBrow, levelTextures, levelImages, levelModels, levelOuter, cueModel, cueTexture, cueImage, mapTable, mapPlayer, mapBall, koSlideIn, koSlideOut, koSlideThru }
var ctx = 0;
var levelModels, levelTextures, player, camData, waveData, ball, ball2, balls, i, k, n, s, c1, c2, f, f1, f2, vx, vy, vz, vr, dx, dy, dz, df, x1, y1, z1, x2, y2, z2, sf, bk, tx, md;
var ww = window_get_width();
var wh = window_get_height();
if (!ds_exists(ctx, ds_type_grid)) {
    ctx = ds_grid_create(36, 1);
    randomize();
    window_set_caption("POOL [of doom!] by YellowAfterlife");
    application_surface_enable(false);
    display_reset(0, true);
    display_set_windows_alternate_sync(true);
    draw_set_alpha_test(true);
    room_speed = 60;
    background_color = $FFFFBD;
    d3d_start();
    d3d_set_culling(false);
    d3d_set_hidden(true);
    window_set_cursor(cr_none);
    window_mouse_set(ww / 2, wh / 2);
    ctx[#GameCtx.menu, 0] = true;
    player = undefined;
    player[22] = 0;
    player[Player.health] = 1;
    player[Player.rad] = 6;
    player[Player.alt] = 20;
    player[Player.ball] = undefined;
    ctx[#GameCtx.player, 0] = player;
    levelModels = ds_list_create();
    ctx[#GameCtx.levelModels, 0] = levelModels;
    levelTextures = ds_list_create();
    ctx[#GameCtx.levelTextures, 0] = levelTextures;
    ctx[#GameCtx.levelImages, 0] = ds_list_create();
    if (true/*"Font"*/) {
        ctx[#GameCtx.glyphs, 0] = ds_list_create();
        ctx[#GameCtx.glyphsRaw, 0] = ds_list_create();
        f = 0.125;
        for (k = 0; k < 2; k += 1) {
            for (i = 0; i < 13; i += 1) {
                s = string_char_at("0123456789.KO", i + 1);
                md = d3d_model_create();
                d3d_model_primitive_begin(md, pr_trianglelist);
                if (i == 1) {
                    x1 = 0;
                    x2 = x1 + 0.3;
                    y1 = 0;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    x1 = 0.2;
                    x2 = x1 + 0.1;
                    y1 = 0.1;
                    y2 = y1 + 0.8;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "0235789") > 0) {
                    x1 = 0;
                    x2 = x1 + 0.5;
                    y1 = 0;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "0123568") > 0) {
                    x1 = 0;
                    x2 = x1 + 0.5;
                    y1 = 0.9;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                f1 = 0.1;
                f2 = 0.55;
                if (string_pos(s, "K46") > 0) f1 = 0;
                if (string_pos(s, "045689K") > 0) {
                    x1 = 0;
                    x2 = x1 + 0.1;
                    y1 = f1;
                    y2 = y1 + (f2 - f1);
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "0234789") > 0) {
                    x1 = 0.4;
                    x2 = x1 + 0.1;
                    y1 = f1;
                    y2 = y1 + (f2 - f1);
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                f1 = 0.55;
                f2 = 0.9;
                if (string_pos(s, "K479") > 0) f2 = 1;
                if (string_pos(s, "0268K") > 0) {
                    x1 = 0;
                    x2 = x1 + 0.1;
                    y1 = f1;
                    y2 = y1 + (f2 - f1);
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "03456789") > 0) {
                    x1 = 0.4;
                    x2 = x1 + 0.1;
                    y1 = f1;
                    y2 = y1 + (f2 - f1);
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "23456789K") > 0) {
                    f1 = 0.1;
                    f2 = 0.4;
                    if (string_pos(s, "2") > 0) f1 = 0;
                    if (string_pos(s, "56") > 0) f2 += 0.1;
                    x1 = f1;
                    x2 = x1 + (f2 - f1);
                    y1 = 0.45;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, ".") > 0) {
                    x1 = 0;
                    x2 = x1 + 0.1;
                    y1 = 0.9;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                }
                if (string_pos(s, "K") > 0) {
                    x1 = 0.4;
                    x2 = x1 + 0.1;
                    y1 = 0;
                    y2 = y1 + 0.45;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    x1 = 0.4;
                    x2 = x1 + 0.1;
                    y1 = 0.55;
                    y2 = y1 + 0.45;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    y1 = 0.45;
                    x1 = 0.4 + (0.5 - y1) * f;
                    y2 = 0.45;
                    x2 = 0.5 + (0.5 - y2) * f;
                    z2 = 0.55;
                    z1 = 0.4 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                    y1 = 0.5;
                    x1 = 0.45 + (0.5 - y1) * f;
                    y2 = 0.55;
                    x2 = 0.4 + (0.5 - y2) * f;
                    z2 = 0.55;
                    z1 = 0.5 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                }
                if (string_pos(s, "O") > 0) {
                    y1 = 0;
                    x1 = 0.1 + (0.5 - y1) * f;
                    y2 = 0.1;
                    x2 = (0.5 - y2) * f;
                    z2 = 0.1;
                    z1 = 0.1 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                    x1 = 0.1;
                    x2 = x1 + 0.3;
                    y1 = 0;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    y1 = 0;
                    x1 = 0.4 + (0.5 - y1) * f;
                    y2 = 0.1;
                    x2 = 0.4 + (0.5 - y2) * f;
                    z2 = 0.1;
                    z1 = 0.5 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                    x1 = 0;
                    x2 = x1 + 0.1;
                    y1 = 0.1;
                    y2 = y1 + 0.8;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    x1 = 0.4;
                    x2 = x1 + 0.1;
                    y1 = 0.1;
                    y2 = y1 + 0.8;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    y1 = 0.9;
                    x1 = (0.5 - y1) * f;
                    y2 = 0.9;
                    x2 = 0.1 + (0.5 - y2) * f;
                    z2 = 1;
                    z1 = 0.1 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                    x1 = 0.1;
                    x2 = x1 + 0.3;
                    y1 = 0.9;
                    y2 = y1 + 0.1;
                    z1 = x1 + (0.5 - y2) * f;
                    z2 = x2 + (0.5 - y2) * f;
                    x1 += (0.5 - y1) * f;
                    x2 += (0.5 - y1) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, z1, y2, 0);
                    d3d_model_vertex(md, x2, y1, 0);
                    d3d_model_vertex(md, z2, y2, 0);
                    y1 = 0.9;
                    x1 = 0.4 + (0.5 - y1) * f;
                    y2 = 0.9;
                    x2 = 0.5 + (0.5 - y2) * f;
                    z2 = 1;
                    z1 = 0.4 + (0.5 - z2) * f;
                    d3d_model_vertex(md, x1, y1, 0);
                    d3d_model_vertex(md, x2, y2, 0);
                    d3d_model_vertex(md, z1, z2, 0);
                }
                d3d_model_primitive_end(md);
                if (k > 0) ds_list_set(ctx[#GameCtx.glyphsRaw, 0], i, md); else ds_list_set(ctx[#GameCtx.glyphs, 0], i, md);
            }
            f = 0;
        }
    }
    if (true/*"Level textures"*/) {
        sf = surface_create(16, 16);
        surface_set_target(sf);
        draw_clear(-1);
        surface_reset_target();
        ctx[#GameCtx.white16, 0] = background_create_from_surface(sf, 0, 0, surface_get_width(sf), surface_get_height(sf), false, false);
        for (i = 0; i < 4; i += 1) {
            switch (i) {
                case 0:
                    c1 = 13602631;
                    c2 = 15179856;
                    break;
                case 1:
                    c1 = 3626870;
                    c2 = 3891073;
                    break;
                case 2:
                    c1 = 4026783;
                    c2 = 4488882;
                    break;
                case 3:
                    c1 = 3585132;
                    c2 = 4049273;
                    break;
                default:
                    c1 = 0;
                    c2 = 0;
            }
            surface_set_target(sf);
            draw_clear(c1);
            draw_background_ext(ctx[#GameCtx.white16, 0], 0, 0, 0.5, 0.5, 0, c2, 1);
            draw_background_ext(ctx[#GameCtx.white16, 0], 8, 8, 0.5, 0.5, 0, c2, 1);
            surface_reset_target();
            bk = background_create_from_surface(sf, 0, 0, surface_get_width(sf), surface_get_height(sf), false, false);
            ds_list_set(ctx[#GameCtx.levelImages, 0], i, bk);
            levelTextures[|i] = background_get_texture(bk);
        }
        surface_free(sf);
    }
    if (true/*"Level models"*/) {
        for (i = 0; i < 4; i += 1) {
            md = d3d_model_create();
            d3d_model_primitive_begin(md, pr_trianglelist);
            levelModels[|i] = md;
        }
        md = d3d_model_create();
        d3d_model_primitive_begin(md, pr_trianglelist);
        for (i = -1; i <= 1; i += 2) {
            x1 = 168. * i;
            y1 = -212.;
            x2 = 640. * i;
            y2 = 212.;
            z1 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            x1 = -640.;
            y1 = 212. * i;
            x2 = 640.;
            y2 = 684. * i;
            z1 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
        }
        d3d_model_primitive_end(md);
        ctx[#GameCtx.levelOuter, 0] = md;
        md = levelModels[|GameLevel.cover];
        f = 0.001;
        x1 = -(118. + f);
        y1 = -20.;
        x2 = 118. + f;
        y2 = 20;
        z1 = 0;
        d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
        d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
        d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
        d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
        d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
        d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
        for (i = -1; i <= 1; i += 2) {
            x1 = -128.;
            y1 = (20 - f) * i;
            x2 = 128;
            y2 = (152. + f) * i;
            z1 = 0;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            x1 = -(108. + f);
            y1 = 172 * i;
            x2 = 108. + f;
            y2 = 152. * i;
            z1 = 0;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            x1 = -108.;
            y1 = 172 * i;
            x2 = 108.;
            y2 = 192. * i;
            z1 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            x1 = 158. * i;
            y1 = -20. * i;
            x2 = 168. * i;
            y2 = 20 * i;
            z1 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            x1 = -168.;
            y1 = 192. * i;
            x2 = 168.;
            y2 = 212. * i;
            z1 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
            d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
            d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            for (k = -1; k <= 1; k += 2) {
                x1 = 128 * i;
                y1 = 20 * k;
                x2 = 148. * i;
                y2 = 152. * k;
                z1 = 32;
                d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
                d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
                d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
                d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
                d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
                d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
                x1 = 148. * i;
                y1 = 20 * k;
                x2 = 168. * i;
                y2 = 192. * k;
                z1 = 32;
                d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
                d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
                d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
                d3d_model_vertex_texture(md, x2, y1, z1, (x2 + y1) / 32, (x2 - y1) / 32);
                d3d_model_vertex_texture(md, x1, y2, z1, (x1 + y2) / 32, (x1 - y2) / 32);
                d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
            }
        }
        md = levelModels[|GameLevel.walls];
        for (i = -1; i <= 1; i += 2) {
            for (n = -1; n <= 1; n += 2) {
                x1 = 128 * i;
                y1 = 20 * n;
                z1 = 0;
                x2 = 128 * i;
                y2 = 152. * n;
                z2 = 32;
                d3d_model_vertex_texture(md, x1, y1, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z2, 0.25, z2 / 32 * 4);
            }
            x1 = -108.;
            y1 = 172 * i;
            z1 = 0;
            x2 = 108.;
            y2 = 172 * i;
            z2 = 32;
            d3d_model_vertex_texture(md, x1, y1, z1, 0.25, z1 / 32 * 4);
            d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
            d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
            d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
            d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
            d3d_model_vertex_texture(md, x2, y2, z2, 0.25, z2 / 32 * 4);
        }
        md = levelModels[|GameLevel.holes];
        for (i = -1; i <= 1; i += 2) {
            for (k = -1; k <= 1; k += 2) {
                x1 = 128 * i;
                y1 = 20 * k;
                z1 = 0;
                x2 = 138. * i;
                y2 = 20 * k;
                z2 = 32;
                d3d_model_vertex_texture(md, x1, y1, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                d3d_model_vertex_texture(md, x1, y1, z2, 0.25, z2 / 32 * 4);
                d3d_model_vertex_texture(md, x2, y2, z2, 0.25, z2 / 32 * 4);
            }
        }
        for (var holeX = -1; holeX <= 1; holeX += 2) {
            for (var holeY = -1; holeY <= 1; holeY += 1) {
                if (holeX > 0) {
                    f1 = 90 + 90 * max(0, -holeY);
                    f2 = 270 - 90 * max(0, holeY);
                } else {
                    f1 = -90 + 90 * max(0, holeY);
                    f2 = 90 - 90 * max(0, -holeY);
                }
                x1 = 128 * holeX;
                if (holeY == 0) x1 += 10 * holeX;
                y1 = 172 * holeY;
                md = ds_list_find_value(ctx[#GameCtx.levelModels, 0], GameLevel.cover);
                z1 = 0;
                for (i = 0; i < 2; i += 1) {
                    for (f = f1; f < f2; f += 15) {
                        x2 = lengthdir_x(20, f);
                        y2 = lengthdir_y(20, f);
                        vr = max(abs(x2), abs(y2));
                        vx = x1 + x2;
                        vy = y1 + y2;
                        d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                        vx = x1 + x2 / vr * 20;
                        vy = y1 + y2 / vr * 20;
                        d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                        x2 = lengthdir_x(20, f + 15);
                        y2 = lengthdir_y(20, f + 15);
                        vr = max(abs(x2), abs(y2));
                        vx = x1 + x2 / vr * 20;
                        vy = y1 + y2 / vr * 20;
                        for (k = 0; k < 2; k += 1) {
                            d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                        }
                        vx = x1 + x2;
                        vy = y1 + y2;
                        d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                        vx = x1 + lengthdir_x(20, f);
                        vy = y1 + lengthdir_y(20, f);
                        d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                    }
                    if (i == 0) {
                        f = f1;
                        f1 = f2;
                        f2 = f + 360;
                        z1 = 32;
                    }
                }
                md = levelModels[|GameLevel.holes];
                z1 = 0;
                z2 = 32;
                for (i = 0; i < 2; i += 1) {
                    for (f = f1; f < f2; f += 15) {
                        vx = x1 + lengthdir_x(20, f);
                        vy = y1 + lengthdir_y(20, f);
                        x2 = x1 + lengthdir_x(20, f + 15);
                        y2 = y1 + lengthdir_y(20, f + 15);
                        d3d_model_vertex_texture(md, vx, vy, z1, 0.25, z1 / 32 * 4);
                        d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                        d3d_model_vertex_texture(md, vx, vy, z2, 0.25, z2 / 32 * 4);
                        d3d_model_vertex_texture(md, vx, vy, z2, 0.25, z2 / 32 * 4);
                        d3d_model_vertex_texture(md, x2, y2, z1, 0.25, z1 / 32 * 4);
                        d3d_model_vertex_texture(md, x2, y2, z2, 0.25, z2 / 32 * 4);
                    }
                    f1 = 0;
                    f2 = 360;
                    z1 = -32;
                    z2 = 0;
                }
                z1 = -32;
                md = levelModels[|GameLevel.holes];
                for (i = 0; i < 2; i += 1) {
                    for (f = 0; f < 360; f += 15) {
                        vx = x1 + lengthdir_x(20, f);
                        vy = y1 + lengthdir_y(20, f);
                        x2 = x1 + lengthdir_x(20, f + 15);
                        y2 = y1 + lengthdir_y(20, f + 15);
                        d3d_model_vertex_texture(md, x1, y1, z1, (x1 + y1) / 32, (x1 - y1) / 32);
                        d3d_model_vertex_texture(md, vx, vy, z1, (vx + vy) / 32, (vx - vy) / 32);
                        d3d_model_vertex_texture(md, x2, y2, z1, (x2 + y2) / 32, (x2 - y2) / 32);
                    }
                    z1 = -8;
                    md = levelModels[|GameLevel.water];
                }
            }
        }
        for (i = 0; i < 4; i += 1) {
            d3d_model_primitive_end(levelModels[|i]);
        }
    }
    if (true/*"Cue"*/) {
        md = d3d_model_create();
        f = 0.05;
        d3d_model_cylinder(md, -f, -f, 0, f, f, f * 64, 1, 1, true, 8);
        ctx[#GameCtx.cueModel, 0] = md;
        sf = surface_create(4, 64);
        surface_set_target(sf);
        draw_clear(-1);
        f1 = 1;
        f2 = 32;
        draw_background_ext(ctx[#GameCtx.white16, 0], 0, f1, 0.25, f2 / 16, 0, $BCE3E7, 1);
        f1 += f2;
        f2 = 1;
        draw_background_ext(ctx[#GameCtx.white16, 0], 0, f1, 0.25, f2 / 16, 0, $3B5F81, 1);
        f1 += f2;
        f2 = 32;
        draw_background_ext(ctx[#GameCtx.white16, 0], 0, f1, 0.25, f2 / 16, 0, $375776, 1);
        surface_reset_target();
        bk = background_create_from_surface(sf, 0, 0, surface_get_width(sf), surface_get_height(sf), false, false);
        ctx[#GameCtx.cueImage, 0] = bk;
        ctx[#GameCtx.cueTexture, 0] = background_get_texture(bk);
        surface_free(sf);
    }
    n = 12;
    if (true/*"Ball shadow"*/) {
        md = d3d_model_create();
        d3d_model_cone(md, -6., -6., 0, 6, 6, 0, 1, 1, false, n);
        ctx[#GameCtx.ballShadow, 0] = md;
    }
    if (true/*"Ball brow"*/) {
        md = d3d_model_create();
        d3d_model_floor(md, -1.1, 0, 0, 1.1, 0.7, 0, 1, 1);
        ctx[#GameCtx.ballBrow, 0] = md;
    }
    if (true/*"Ball eye"*/) {
        md = d3d_model_create();
        d3d_model_primitive_begin(md, pr_trianglelist);
        x1 = 1;
        y1 = 0;
        for (f = 30.; f <= 360; f += 30.) {
            x2 = lengthdir_x(1, f);
            y2 = lengthdir_y(1, f);
            if (y2 < -0.5) {
                x2 *= y2 / -0.5;
                y2 = -0.5;
            }
            d3d_model_vertex(md, 0, 0, 0);
            d3d_model_vertex(md, x1, y1, 0);
            d3d_model_vertex(md, x2, y2, 0);
            x1 = x2;
            y1 = y2;
        }
        d3d_model_primitive_end(md);
        ctx[#GameCtx.ballEye, 0] = md;
    }
    if (true/*"Ball outer"*/) {
        sf = surface_create(256, 128);
        md = d3d_model_create();
        d3d_model_ellipsoid(md, -6., -6., 6, 6, 6, -6., 1, 1, n);
        ctx[#GameCtx.ballOuterModel, 0] = md;
        surface_set_target(sf);
        draw_clear_alpha(0, 0);
        draw_background_ext(ctx[#GameCtx.white16, 0], 0, 24, 16., 8., 0, -1, 1);
        surface_reset_target();
        bk = background_create_from_surface(sf, 0, 0, surface_get_width(sf), surface_get_height(sf), false, false);
        ctx[#GameCtx.ballOuterImage, 0] = bk;
        ctx[#GameCtx.ballOuterTexture, 0] = background_get_texture(bk);
        surface_free(sf);
    }
    if (true/*"Ball inner"*/) {
        md = d3d_model_create();
        d3d_model_primitive_begin(md, pr_trianglelist);
        f1 = 3.36;
        z1 = 4.8;
        x1 = f1;
        y1 = 0;
        z2 = z1;
        for (f = 360 / n; f <= 360; f += 360 / n) {
            x2 = lengthdir_x(f1, f);
            y2 = lengthdir_y(f1, f);
            d3d_model_vertex_texture(md, 0, 0, 5.1, 0.5, 0.5);
            d3d_model_vertex_texture(md, x1, y1, z1, (1 + y1 / f1) / 2 - x1 / f1 / 16, (1 + x1 / f1) / 2);
            d3d_model_vertex_texture(md, x2, y2, z2, (1 + y2 / f1) / 2 - x2 / f1 / 16, (1 + x2 / f1) / 2);
            x1 = x2;
            y1 = y2;
        }
        d3d_model_primitive_end(md);
        ctx[#GameCtx.ballInnerModel, 0] = md;
        ctx[#GameCtx.ballInnerTexture, 0] = ds_list_create();
        ctx[#GameCtx.ballInnerImage, 0] = ds_list_create();
        sf = surface_create(128, 128);
        for (i = 0; i < 10; i += 1) {
            surface_set_target(sf);
            draw_clear_alpha(-1, 1);
            draw_set_color($404040);
            d3d_transform_stack_push();
            d3d_transform_add_scaling(80, 64, 1);
            d3d_transform_add_translation(64, 64, 0);
            d3d_model_draw(ds_list_find_value(ctx[#GameCtx.glyphsRaw, 0], i), -0.25, -0.5, 0, -1);
            d3d_transform_stack_pop();
            surface_reset_target();
            bk = background_create_from_surface(sf, 0, 0, surface_get_width(sf), surface_get_height(sf), false, false);
            ds_list_set(ctx[#GameCtx.ballInnerImage, 0], i, bk);
            ds_list_set(ctx[#GameCtx.ballInnerTexture, 0], i, background_get_texture(bk));
        }
        surface_free(sf);
    }
    if (true/*"Ball colors"*/) {
        ctx[#GameCtx.ballColors, 0] = ds_list_create();
        ds_list_add(ctx[#GameCtx.ballColors, 0], $404040);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $48DBF2);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $E6A050);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $4D64F9);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $F771BF);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $4496F4);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $5EF2A3);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $475FD3);
        ds_list_add(ctx[#GameCtx.ballColors, 0], $7F6F66);
    }
    ctx[#GameCtx.balls, 0] = ds_list_create();
    if (true/*"Minimap"*/) {
        if (true/*"Table"*/) {
            md = d3d_model_create();
            d3d_model_primitive_begin(md, pr_linelist);
            d3d_model_vertex(md, -128., -172., 0);
            d3d_model_vertex(md, 128, -172., 0);
            d3d_model_vertex(md, -128., -172., 0);
            d3d_model_vertex(md, -128., 172, 0);
            d3d_model_vertex(md, 128, -172., 0);
            d3d_model_vertex(md, 128, 172, 0);
            d3d_model_vertex(md, -128., 172, 0);
            d3d_model_vertex(md, 128, 172, 0);
            d3d_model_primitive_end(md);
            ctx[#GameCtx.mapTable, 0] = md;
        }
        if (true/*"Player"*/) {
            md = d3d_model_create();
            d3d_model_primitive_begin(md, pr_linelist);
            d3d_model_vertex(md, -1, -1, 0);
            d3d_model_vertex(md, 1, 0, 0);
            d3d_model_vertex(md, -1, 1, 0);
            d3d_model_vertex(md, 1, 0, 0);
            d3d_model_vertex(md, 1, 0, 0);
            d3d_model_vertex(md, 3, 0, 0);
            d3d_model_vertex(md, -1, -1, 0);
            d3d_model_vertex(md, -1, 1, 0);
            d3d_model_primitive_end(md);
            ctx[#GameCtx.mapPlayer, 0] = md;
        }
        if (true/*"Ball"*/) {
            md = d3d_model_create();
            d3d_model_primitive_begin(md, pr_trianglelist);
            d3d_model_cone(md, -1, -1, 0, 1, 1, 0, 1, 1, false, 12);
            d3d_model_primitive_end(md);
            ctx[#GameCtx.mapBall, 0] = md;
        }
    }
    if (true/*"Logo"*/) {
        md = d3d_model_create();
        d3d_model_primitive_begin(md, pr_trianglelist);
        d3d_model_vertex(md, 4, 128, 0);
        repeat (2) {
            d3d_model_vertex(md, 15, 120, 0);
            d3d_model_vertex(md, 15, 128, 0);
        }
        d3d_model_vertex(md, 35, 106, 0);
        d3d_model_vertex(md, 15, 120, 0);
        repeat (2) {
            d3d_model_vertex(md, 35, 106, 0);
            d3d_model_vertex(md, 15, 0, 0);
        }
        d3d_model_vertex(md, 35, 60, 0);
        d3d_model_vertex(md, 15, 0, 0);
        d3d_model_vertex(md, 35, 60, 0);
        d3d_model_vertex(md, 35, 40, 0);
        d3d_model_vertex(md, 15, 0, 0);
        d3d_model_vertex(md, 35, 40, 0);
        d3d_model_vertex(md, 35, 15, 0);
        d3d_model_vertex(md, 15, 128, 0);
        repeat (2) {
            d3d_model_vertex(md, 63, 128, 0);
            d3d_model_vertex(md, 35, 106, 0);
        }
        d3d_model_vertex(md, 47, 106, 0);
        d3d_model_vertex(md, 63, 128, 0);
        repeat (2) {
            d3d_model_vertex(md, 47, 106, 0);
            d3d_model_vertex(md, 70, 123, 0);
        }
        d3d_model_vertex(md, 49, 105, 0);
        d3d_model_vertex(md, 49, 105, 0);
        repeat (2) {
            d3d_model_vertex(md, 70, 123, 0);
            d3d_model_vertex(md, 49, 69, 0);
        }
        d3d_model_vertex(md, 70, 64, 0);
        d3d_model_vertex(md, 35, 60, 0);
        repeat (2) {
            d3d_model_vertex(md, 49, 69, 0);
            d3d_model_vertex(md, 35, 40, 0);
        }
        d3d_model_vertex(md, 70, 64, 0);
        for (i = -1; i <= 1; i += 2) {
            d3d_model_vertex(md, 128 + -56 * i, 123, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -49 * i, 128, 0);
                d3d_model_vertex(md, 128 + -36 * i, 104, 0);
            }
            d3d_model_vertex(md, 128 + -34 * i, 105, 0);
            d3d_model_vertex(md, 128 + -49 * i, 128, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -34 * i, 105, 0);
                d3d_model_vertex(md, 128 + -8 * i, 128, 0);
            }
            d3d_model_vertex(md, 128 + -24 * i, 105, 0);
            d3d_model_vertex(md, 128 + -8 * i, 128, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -24 * i, 105, 0);
                d3d_model_vertex(md, 128 + -1 * i, 123, 0);
            }
            d3d_model_vertex(md, 128 + -22 * i, 104, 0);
            d3d_model_vertex(md, 128 + -56 * i, 123, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -36 * i, 104, 0);
                d3d_model_vertex(md, 128 + -56 * i, 47, 0);
            }
            d3d_model_vertex(md, 128 + -36 * i, 59, 0);
            d3d_model_vertex(md, 128 + -22 * i, 104, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -1 * i, 123, 0);
                d3d_model_vertex(md, 128 + -22 * i, 49, 0);
            }
            d3d_model_vertex(md, 128 + -1 * i, 35, 0);
            d3d_model_vertex(md, 128 + -36 * i, 59, 0);
            repeat (2) {
                d3d_model_vertex(md, 128 + -56 * i, 47, 0);
                d3d_model_vertex(md, 128 + -22 * i, 49, 0);
            }
            d3d_model_vertex(md, 128 + -21 * i, 20, 0);
            d3d_model_vertex(md, 128 + -22 * i, 49, 0);
            d3d_model_vertex(md, 128 + -21 * i, 20, 0);
            d3d_model_vertex(md, 128 + -1 * i, 35, 0);
        }
        d3d_model_vertex(md, 190, 128, 0);
        repeat (2) {
            d3d_model_vertex(md, 186, 125, 0);
            d3d_model_vertex(md, 218, 128, 0);
        }
        d3d_model_vertex(md, 207, 120, 0);
        d3d_model_vertex(md, 186, 125, 0);
        repeat (2) {
            d3d_model_vertex(md, 207, 120, 0);
            d3d_model_vertex(md, 186, 40, 0);
        }
        d3d_model_vertex(md, 207, 59, 0);
        d3d_model_vertex(md, 207, 59, 0);
        repeat (2) {
            d3d_model_vertex(md, 186, 40, 0);
            d3d_model_vertex(md, 239, 36, 0);
        }
        d3d_model_vertex(md, 241, 0, 0);
        d3d_model_vertex(md, 239, 36, 0);
        d3d_model_vertex(md, 241, 37, 0);
        d3d_model_vertex(md, 241, 0, 0);
        d3d_model_primitive_end(md);
        ctx[#GameCtx.logo, 0] = md;
        ctx[#GameCtx.logoShadow, 0] = -1;
        ctx[#GameCtx.logoColor, 0] = -1;
    }
    camData = undefined;
    camData[5] = 0;
    camData[CameraData.x1] = 200;
    camData[CameraData.y1] = -200;
    camData[CameraData.z1] = 150;
    ctx[#GameCtx.cameraData, 0] = camData;
    ctx[#GameCtx.score, 0] = -1;
} else {
    player = ctx[#GameCtx.player, 0];
    levelModels = ctx[#GameCtx.levelModels, 0];
    levelTextures = ctx[#GameCtx.levelTextures, 0];
    camData = ctx[#GameCtx.cameraData, 0];
}
waveData = ctx[#GameCtx.waveData, 0];
balls = ctx[#GameCtx.balls, 0];
if (keyboard_check_pressed(27)) {
    ds_list_destroy(ctx[#GameCtx.balls, 0]);
    background_delete(ctx[#GameCtx.white16, 0]);
    d3d_model_destroy(ctx[#GameCtx.logo, 0]);
    sf = ctx[#GameCtx.logoColor, 0];
    if (surface_exists(sf)) surface_free(sf);
    sf = ctx[#GameCtx.logoShadow, 0];
    if (surface_exists(sf)) surface_free(sf);
    n = ds_list_size(ctx[#GameCtx.glyphs, 0]);
    for (i = 0; i < n; i += 1) {
        d3d_model_destroy(ds_list_find_value(ctx[#GameCtx.glyphs, 0], i));
        d3d_model_destroy(ds_list_find_value(ctx[#GameCtx.glyphsRaw, 0], i));
    }
    ds_list_destroy(ctx[#GameCtx.glyphs, 0]);
    ds_list_destroy(ctx[#GameCtx.glyphsRaw, 0]);
    d3d_model_destroy(ctx[#GameCtx.ballOuterModel, 0]);
    background_delete(ctx[#GameCtx.ballOuterImage, 0]);
    n = ds_list_size(ctx[#GameCtx.ballInnerImage, 0]);
    for (i = 0; i < n; i += 1) {
        background_delete(ds_list_find_value(ctx[#GameCtx.ballInnerImage, 0], i));
    }
    d3d_model_destroy(ctx[#GameCtx.ballInnerModel, 0]);
    ds_list_destroy(ctx[#GameCtx.ballColors, 0]);
    d3d_model_destroy(ctx[#GameCtx.ballShadow, 0]);
    d3d_model_destroy(ctx[#GameCtx.ballBrow, 0]);
    d3d_model_destroy(ctx[#GameCtx.ballEye, 0]);
    var this12 = ctx[#GameCtx.levelImages, 0];
    n = 4;
    for (i = 0; i < n; i += 1) {
        background_delete(ds_list_find_value(ctx[#GameCtx.levelImages, 0], i));
        d3d_model_destroy(ds_list_find_value(ctx[#GameCtx.levelModels, 0], i));
    }
    ds_list_destroy(ctx[#GameCtx.levelImages, 0]);
    ds_list_destroy(ctx[#GameCtx.levelModels, 0]);
    ds_list_destroy(ctx[#GameCtx.levelTextures, 0]);
    background_delete(ctx[#GameCtx.cueImage, 0]);
    d3d_model_destroy(ctx[#GameCtx.cueModel, 0]);
    d3d_model_destroy(ctx[#GameCtx.mapTable, 0]);
    d3d_model_destroy(ctx[#GameCtx.mapPlayer, 0]);
    d3d_model_destroy(ctx[#GameCtx.mapBall, 0]);
    ds_grid_destroy(ctx);
    game_end();
    return 0;
}
if (keyboard_check_pressed(vk_f5)) display_reset(0, true);
if (keyboard_check_pressed(vk_f6) && (display_aa & 2) != 0) display_reset(2, true);
if (keyboard_check_pressed(vk_f7) && (display_aa & 4) != 0) display_reset(4, true);
if (keyboard_check_pressed(vk_f8) && (display_aa & 8) != 0) display_reset(8, true);
var aim = 0;
var alive = player[Player.health] > 0;
if (ctx[#GameCtx.menu, 0]) {
    if (mouse_check_button_pressed(mb_left)) {
        ctx[#GameCtx.menu, 0] = false;
        ctx[#GameCtx.score, 0] = 0;
        player = undefined;
        player[22] = 0;
        player[Player.health] = 1;
        player[Player.healthEase] = 1;
        player[Player.rad] = 6;
        player[Player.alt] = 20;
        player[Player.ball] = undefined;
        player[@Player.yaw] = point_direction(camData[CameraData.x1], camData[CameraData.y1], camData[CameraData.x2], camData[CameraData.y2]);
        ctx[#GameCtx.player, 0] = player;
        ds_list_clear(balls);
        waveData = undefined;
        waveData[3] = 0;
        ctx[#GameCtx.waveData, 0] = waveData;
    } else {
        f2 = current_time / 400 + 45;
        f = 0.01;
        camData[@CameraData.z1] = lerp(camData[CameraData.z1], 72., f);
        if (camData[CameraData.z1] > 32) {
            camData[@CameraData.x1] = lerp(camData[CameraData.x1], lengthdir_x(128, f2), f);
            camData[@CameraData.y1] = lerp(camData[CameraData.y1], lengthdir_y(128, f2), f);
        }
        camData[@CameraData.x2] = lerp(camData[CameraData.x2], 0, f);
        camData[@CameraData.y2] = lerp(camData[CameraData.y2], 0, f);
        camData[@CameraData.z2] = lerp(camData[CameraData.z2], 32, f);
    }
} else if (alive) {
    if (true/*"Waves"*/) {
        if (waveData[WaveData.left] > 0) {
            if (waveData[WaveData.spawn] >= 1) {
                waveData[@WaveData.spawn] = 0;
                waveData[@WaveData.left] -= 1;
                i = waveData[WaveData.wave];
                vr = 6 * random_range(0.8, min(1.7, power(i, 0.3)));
                ball = undefined;
                ball[Ball.rad] = vr;
                ball[Ball.x] = random_range(-(128 - vr), 128 - vr);
                ball[Ball.y] = random_range(-(172 - vr), 172 - vr);
                ball[Ball.z] = 92.;
                ball[Ball.vz] = -8;
                ball[Ball.boost] = random_range(0.9, 0.2 + power(i, 0.4));
                ball[Ball.rush] = random_range(0.9, 0.2 + power(i, 0.4));
                ball[Ball.number] = irandom_range(1, 8);
                ds_list_add(balls, ball);
            } else waveData[@WaveData.spawn] += 1 / (300 / (10 + waveData[WaveData.wave]));
        } else if (ds_list_size(balls) <= 0) {
            if (waveData[WaveData.next] >= 1) {
                waveData[@WaveData.wave] += 1;
                waveData[@WaveData.left] = 1 + waveData[WaveData.wave];
                waveData[@WaveData.next] = 0;
            } else waveData[@WaveData.next] += (1 / 300);
        }
    }
    if (window_has_focus()) {
        x1 = window_get_width() / 2;
        y1 = window_get_height() / 2;
        x2 = (window_mouse_get_x() - x1) * -0.2;
        y2 = (window_mouse_get_y() - y1) * 0.2;
        if (player[Player.ease] >= 1) {
            player[@Player.cueX] = lerp(player[Player.cueX], 0, 0.2) + x2 / 180;
            player[@Player.cueY] = lerp(player[Player.cueY], 0, 0.2) + y2 / 90;
            player[@Player.yaw] += x2;
            player[@Player.tilt] += y2;
            player[@Player.tilt] = clamp(player[Player.tilt], -85, 85);
        }
        window_mouse_set(x1, y1);
    }
    if (player[Player.bop] > 0) {
        player[@Player.bop] -= 0.05;
        player[@Player.regen] = 0;
    } else player[@Player.regen] = min(player[Player.regen] + (1 / 300), 1);
    if (player[Player.health] < 1) player[@Player.health] = min(player[Player.health] + player[Player.regen] / 600, 1);
    if (true/*"Attack"*/) {
        aim = player[Player.cueZ];
        if (mouse_check_button_released(mb_left) && aim > 0.1) {
            f1 = player[Player.yaw];
            f2 = player[Player.tilt];
            dx = lengthdir_x(lengthdir_x(1, f2), f1);
            dy = lengthdir_y(lengthdir_x(1, f2), f1);
            dz = lengthdir_y(1, f2) / 4;
            df = aim * -0.5;
            player[@Player.cx] += dx * df;
            player[@Player.cy] += dy * df;
            player[@Player.cz] += dz * df;
            f2 = aim * 6;
            vr = 16;
            vx = player[Player.x] + dx * vr;
            vy = player[Player.y] + dy * vr;
            vz = player[Player.z] + dz * vr;
            vr = 12;
            n = ds_list_size(balls);
            for (i = 0; i < n; i += 1) {
                ball = balls[|i];
                x2 = ball[Ball.x] - vx;
                y2 = ball[Ball.y] - vy;
                z2 = ball[Ball.z] + 6 - vz;
                f = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
                if (f < vr + ball[Ball.rad]) {
                    df = f2 / (ball[Ball.rad] / 6);
                    ball[@Ball.cx] += dx * df;
                    ball[@Ball.cy] += dy * df;
                    ball[@Ball.cz] = ball[Ball.cz] / 3 + dz * df;
                }
            }
            aim = lerp(aim, 0, 0.2);
        } else if (mouse_check_button(mb_left)) {
            aim = min(aim + 0.05, 1);
        } else aim = lerp(aim, 0, 0.2);
        player[@Player.cueZ] = aim;
    }
    if (true/*"XY accel"*/) {
        vx = player[Player.vx];
        vy = player[Player.vy];
        x2 = keyboard_check(ord("D")) - keyboard_check(ord("A"));
        y2 = keyboard_check(ord("W")) - keyboard_check(ord("S"));
        z2 = 0.4 * (1 - aim * 0.4);
        vx += lengthdir_x(z2, player[Player.yaw]) * y2;
        vy += lengthdir_y(z2, player[Player.yaw]) * y2;
        vx += lengthdir_x(z2, player[Player.yaw] - 90) * x2;
        vy += lengthdir_y(z2, player[Player.yaw] - 90) * x2;
        z2 = sqrt(vx * vx + vy * vy);
        if (z2 > 0) {
            z2 = clamp(z2 - 0.2, 0, 2 * (1 - aim * 0.4)) / z2;
            vx *= z2;
            vy *= z2;
        }
        player[@Player.vx] = vx;
        player[@Player.vy] = vy;
    }
    if (true/*"Knockback decay"*/) {
        vx = player[Player.cx];
        vy = player[Player.cy];
        vz = player[Player.cz];
        z2 = sqrt(vx * vx + vy * vy + vz * vz);
        if (z2 > 0) {
            z2 = max(z2 * 0.95 - 0.05, 0) / z2;
            player[@Player.cx] = vx * z2;
            player[@Player.cy] = vy * z2;
            player[@Player.cz] = vz * z2;
        }
    }
    if (true/*"XY movement"*/) {
        vr = player[Player.rad];
        vz = player[Player.z];
        vy = player[Player.y];
        x1 = player[Player.vx] + player[Player.cx];
        vx = player[Player.x] + x1;
        if (true/*"findAlt"*/) {
            f = 0;
            for (f1 = -1; true; f1 = f1 + 2) {
                if (!(f1 <= 1)) break;
                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                    f = -32;
                    break;
                }
                for (f2 = -1; true; f2 = f2 + 2) {
                    if (!(f2 <= 1)) break;
                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                        f = -32;
                        break;
                    }
                }
                if (f != 0) break;
            }
            if (f == 0) {
                if (abs(vy) < 20 - vr) {
                    if (abs(vx) > 138.) f = 32;
                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                    f = 32;
                }
            }
        }
        if (vz < f) {
            k = sign(x1);
            for (i = floor(abs(x1)); i > 0; i -= 1) {
                vx = player[Player.x] + k;
                if (true/*"findAlt"*/) {
                    f = 0;
                    for (f1 = -1; true; f1 = f1 + 2) {
                        if (!(f1 <= 1)) break;
                        if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                            f = -32;
                            break;
                        }
                        for (f2 = -1; true; f2 = f2 + 2) {
                            if (!(f2 <= 1)) break;
                            if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                f = -32;
                                break;
                            }
                        }
                        if (f != 0) break;
                    }
                    if (f == 0) {
                        if (abs(vy) < 20 - vr) {
                            if (abs(vx) > 138.) f = 32;
                        } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                            f = 32;
                        }
                    }
                }
                if (vz >= f) {
                    player[@Player.x] = vx;
                } else {
                    vy += 1;
                    if (true/*"findAlt"*/) {
                        f = 0;
                        for (f1 = -1; true; f1 = f1 + 2) {
                            if (!(f1 <= 1)) break;
                            if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                f = -32;
                                break;
                            }
                            for (f2 = -1; true; f2 = f2 + 2) {
                                if (!(f2 <= 1)) break;
                                if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                            }
                            if (f != 0) break;
                        }
                        if (f == 0) {
                            if (abs(vy) < 20 - vr) {
                                if (abs(vx) > 138.) f = 32;
                            } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                f = 32;
                            }
                        }
                    }
                    if (vz >= f) {
                        player[@Player.x] = vx;
                        player[@Player.y] = vy;
                    } else {
                        vy -= 2;
                        if (true/*"findAlt"*/) {
                            f = 0;
                            for (f1 = -1; true; f1 = f1 + 2) {
                                if (!(f1 <= 1)) break;
                                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                                for (f2 = -1; true; f2 = f2 + 2) {
                                    if (!(f2 <= 1)) break;
                                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                        f = -32;
                                        break;
                                    }
                                }
                                if (f != 0) break;
                            }
                            if (f == 0) {
                                if (abs(vy) < 20 - vr) {
                                    if (abs(vx) > 138.) f = 32;
                                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                    f = 32;
                                }
                            }
                        }
                        if (vz >= f) {
                            player[@Player.x] = vx;
                            player[@Player.y] = vy;
                        } else break;
                    }
                }
            }
            player[@Player.vx] = 0;
            player[@Player.cx] *= -0.5;
        } else player[@Player.x] = vx;
        y1 = player[Player.vy] + player[Player.cy];
        vx = player[Player.x];
        vy = player[Player.y] + y1;
        if (true/*"findAlt"*/) {
            f = 0;
            for (f1 = -1; true; f1 = f1 + 2) {
                if (!(f1 <= 1)) break;
                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                    f = -32;
                    break;
                }
                for (f2 = -1; true; f2 = f2 + 2) {
                    if (!(f2 <= 1)) break;
                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                        f = -32;
                        break;
                    }
                }
                if (f != 0) break;
            }
            if (f == 0) {
                if (abs(vy) < 20 - vr) {
                    if (abs(vx) > 138.) f = 32;
                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                    f = 32;
                }
            }
        }
        if (vz < f) {
            k = sign(y1);
            for (i = floor(abs(y1)); i > 0; i -= 1) {
                vy = player[Player.y] + k;
                if (true/*"findAlt"*/) {
                    f = 0;
                    for (f1 = -1; true; f1 = f1 + 2) {
                        if (!(f1 <= 1)) break;
                        if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                            f = -32;
                            break;
                        }
                        for (f2 = -1; true; f2 = f2 + 2) {
                            if (!(f2 <= 1)) break;
                            if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                f = -32;
                                break;
                            }
                        }
                        if (f != 0) break;
                    }
                    if (f == 0) {
                        if (abs(vy) < 20 - vr) {
                            if (abs(vx) > 138.) f = 32;
                        } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                            f = 32;
                        }
                    }
                }
                if (vz >= f) {
                    player[@Player.y] = vy;
                } else {
                    vx += 1;
                    if (true/*"findAlt"*/) {
                        f = 0;
                        for (f1 = -1; true; f1 = f1 + 2) {
                            if (!(f1 <= 1)) break;
                            if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                f = -32;
                                break;
                            }
                            for (f2 = -1; true; f2 = f2 + 2) {
                                if (!(f2 <= 1)) break;
                                if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                            }
                            if (f != 0) break;
                        }
                        if (f == 0) {
                            if (abs(vy) < 20 - vr) {
                                if (abs(vx) > 138.) f = 32;
                            } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                f = 32;
                            }
                        }
                    }
                    if (vz >= f) {
                        player[@Player.y] = vy;
                        player[@Player.x] = vx;
                    } else {
                        vx -= 2;
                        if (true/*"findAlt"*/) {
                            f = 0;
                            for (f1 = -1; true; f1 = f1 + 2) {
                                if (!(f1 <= 1)) break;
                                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                                for (f2 = -1; true; f2 = f2 + 2) {
                                    if (!(f2 <= 1)) break;
                                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                        f = -32;
                                        break;
                                    }
                                }
                                if (f != 0) break;
                            }
                            if (f == 0) {
                                if (abs(vy) < 20 - vr) {
                                    if (abs(vx) > 138.) f = 32;
                                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                    f = 32;
                                }
                            }
                        }
                        if (vz >= f) {
                            player[@Player.y] = vy;
                            player[@Player.x] = vx;
                        } else break;
                    }
                }
            }
            player[@Player.vy] = 0;
            player[@Player.cy] *= -0.5;
        } else player[@Player.y] = vy;
    }
    if (true/*"Z axis"*/) {
        vx = player[Player.x];
        vy = player[Player.y];
        vz = player[Player.z];
        vr = player[Player.rad];
        if (true/*"findAlt"*/) {
            f = 0;
            for (f1 = -1; true; f1 = f1 + 2) {
                if (!(f1 <= 1)) break;
                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                    f = -32;
                    break;
                }
                for (f2 = -1; true; f2 = f2 + 2) {
                    if (!(f2 <= 1)) break;
                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                        f = -32;
                        break;
                    }
                }
                if (f != 0) break;
            }
            if (f == 0) {
                if (abs(vy) < 20 - vr) {
                    if (abs(vx) > 138.) f = 32;
                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                    f = 32;
                }
            }
        }
        if (vz > f) player[@Player.vz] -= 1 / 24; else player[@Player.jump] = 8;
        if (player[Player.jump] > 0) {
            if (keyboard_check(ord(" "))) {
                player[@Player.vz] = 1.1;
                player[@Player.jump] = 0;
            } else player[@Player.jump] -= 1;
        }
        z1 = player[Player.vz] + player[Player.cz];
        player[@Player.z] += z1;
        if (z1 < 0 && player[Player.z] <= f) {
            player[@Player.z] = f;
            player[@Player.vz] = 0;
            player[@Player.cz] = 0;
        }
        if (player[Player.z] + player[Player.alt] * 0.5 <= -8) player[@Player.health] = 0;
    }
    if (player[Player.health] > 0) {
        player[@Player.healthEase] += clamp(player[Player.health] - player[Player.healthEase], -0.001, 0.001);
        player[@Player.healthEase] = lerp(player[Player.healthEase], player[Player.health], 0.1);
    }
    if (player[Player.health] > 0 && true/*"Camera"*/) {
        x1 = player[Player.x];
        y1 = player[Player.y];
        z1 = player[Player.z] + player[Player.alt] * 0.7;
        x2 = x1 + lengthdir_x(lengthdir_x(1, player[Player.tilt]), player[Player.yaw]);
        y2 = y1 + lengthdir_y(lengthdir_x(1, player[Player.tilt]), player[Player.yaw]);
        z2 = z1 + lengthdir_y(1, player[Player.tilt]);
        if (player[Player.ease] < 1) {
            f = player[Player.ease];
            player[@Player.ease] = f + 0.02;
            f /= 3;
        } else f = 1;
        camData[@CameraData.x1] = lerp(camData[CameraData.x1], x1, f);
        camData[@CameraData.y1] = lerp(camData[CameraData.y1], y1, f);
        camData[@CameraData.z1] = lerp(camData[CameraData.z1], z1, f);
        camData[@CameraData.x2] = lerp(camData[CameraData.x2], x2, f);
        camData[@CameraData.y2] = lerp(camData[CameraData.y2], y2, f);
        camData[@CameraData.z2] = lerp(camData[CameraData.z2], z2, f);
    }
} else {
    player[@Player.ease] = max(player[Player.ease] - 0.04, 0);
    camData[@CameraData.z2] += 0.003;
}
d3d_set_projection_ext(camData[CameraData.x1], camData[CameraData.y1], camData[CameraData.z1], camData[CameraData.x2], camData[CameraData.y2], camData[CameraData.z2], 0, 0, 1, 75, ww / wh, 0.1, 640);
if (true/*"Balls"*/) {
    n = ds_list_size(balls);
    i = 0;
    while (i < n) {
        ball = balls[|i];
        vr = ball[Ball.rad];
        f = point_direction(ball[Ball.x], ball[Ball.y], player[Player.x], player[Player.y]);
        ball[@Ball.yaw] -= clamp(angle_difference(ball[Ball.yaw], f), -3, 3);
        dx = ball[Ball.cx];
        dy = ball[Ball.cy];
        df = sqrt(dx * dx + dy * dy);
        if (df > 0) {
            df = max(df * 0.99 - 0.05, 0) / df;
            dx *= df;
            dy *= df;
        }
        if (df < 0.16) ball[@Ball.bounces] = 0;
        if (dx != 0 || dy != 0) {
            x1 = ball[Ball.x];
            y1 = ball[Ball.y];
            if (x1 > -128. && x1 < 128 && y1 > -172. && y1 < 172) z1 = 0.5; else z1 = 0.2;
            vx = x1 + dx;
            vy = y1 + dy;
            vz = ball[Ball.z];
            if (true/*"findAlt"*/) {
                f = 0;
                for (f1 = -1; true; f1 = f1 + 2) {
                    if (!(f1 <= 1)) break;
                    if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                        f = -32;
                        break;
                    }
                    for (f2 = -1; true; f2 = f2 + 2) {
                        if (!(f2 <= 1)) break;
                        if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                            f = -32;
                            break;
                        }
                    }
                    if (f != 0) break;
                }
                if (f == 0) {
                    if (abs(vy) < 20 - vr) {
                        if (abs(vx) > 138.) f = 32;
                    } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                        f = 32;
                    }
                }
            }
            if (vz < f) {
                vx -= dx;
                if (true/*"findAlt"*/) {
                    f = 0;
                    for (f1 = -1; true; f1 = f1 + 2) {
                        if (!(f1 <= 1)) break;
                        if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                            f = -32;
                            break;
                        }
                        for (f2 = -1; true; f2 = f2 + 2) {
                            if (!(f2 <= 1)) break;
                            if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                f = -32;
                                break;
                            }
                        }
                        if (f != 0) break;
                    }
                    if (f == 0) {
                        if (abs(vy) < 20 - vr) {
                            if (abs(vx) > 138.) f = 32;
                        } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                            f = 32;
                        }
                    }
                }
                if (vz < f) {
                    vx += dx;
                    vy -= dy;
                    if (true/*"findAlt"*/) {
                        f = 0;
                        for (f1 = -1; true; f1 = f1 + 2) {
                            if (!(f1 <= 1)) break;
                            if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                f = -32;
                                break;
                            }
                            for (f2 = -1; true; f2 = f2 + 2) {
                                if (!(f2 <= 1)) break;
                                if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                            }
                            if (f != 0) break;
                        }
                        if (f == 0) {
                            if (abs(vy) < 20 - vr) {
                                if (abs(vx) > 138.) f = 32;
                            } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                f = 32;
                            }
                        }
                    }
                    if (vz < f) {
                        vx -= dx;
                        dx *= -z1;
                    } else ball[@Ball.x] = vx;
                    dy *= -z1;
                } else {
                    dx *= -z1;
                    ball[@Ball.y] = vy;
                }
            } else {
                ball[@Ball.x] = vx;
                ball[@Ball.y] = vy;
            }
            ball[@Ball.cx] = dx;
            ball[@Ball.cy] = dy;
            vx = ball[Ball.x];
            vy = ball[Ball.y];
            for (k = 0; k < n; k += 1) {
                if (k != i) {
                    ball2 = balls[|k];
                    if (ball2[Ball.col]) continue;
                    x2 = ball2[Ball.x] - vx;
                    y2 = ball2[Ball.y] - vy;
                    z2 = ball2[Ball.z] - vz;
                    f1 = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
                    f2 = ball2[Ball.rad];
                    if (f1 < vr + f2) {
                        x1 = (ball[Ball.cx] * (vr - f2) + 2 * f2 * ball2[Ball.cx]) / (vr + f2);
                        x2 = (ball2[Ball.cx] * (f2 - vr) + 2 * vr * ball[Ball.cx]) / (vr + f2);
                        y1 = (ball[Ball.cy] * (vr - f2) + 2 * f2 * ball2[Ball.cy]) / (vr + f2);
                        y2 = (ball2[Ball.cy] * (f2 - vr) + 2 * vr * ball[Ball.cy]) / (vr + f2);
                        z1 = (ball[Ball.cz] * (vr - f2) + 2 * f2 * ball2[Ball.cz]) / (vr + f2);
                        z2 = (ball2[Ball.cz] * (f2 - vr) + 2 * vr * ball[Ball.cz]) / (vr + f2);
                        ball[@Ball.cx] = x1;
                        ball[@Ball.cy] = y1;
                        ball[@Ball.cz] = z1;
                        ball[@Ball.col] = true;
                        ball2[@Ball.cx] = x2;
                        ball2[@Ball.cy] = y2;
                        ball2[@Ball.cz] = z2;
                        ball2[@Ball.col] = true;
                        ball[@Ball.bounces] += 1;
                        ball2[@Ball.bounces] += 1;
                    }
                }
            }
        }
        dx = ball[Ball.cx];
        dy = ball[Ball.cy];
        df = ball[Ball.jump];
        if (df > 0 && df < 1) {
            f1 = sin(df * pi) * ball[Ball.boost];
            vx = ball[Ball.x] + lengthdir_x(f1, ball[Ball.yaw]);
            vy = ball[Ball.y] + lengthdir_y(f1, ball[Ball.yaw]);
            vz = ball[Ball.z];
            if (true/*"findAlt"*/) {
                f = 0;
                for (f1 = -1; true; f1 = f1 + 2) {
                    if (!(f1 <= 1)) break;
                    if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                        f = -32;
                        break;
                    }
                    for (f2 = -1; true; f2 = f2 + 2) {
                        if (!(f2 <= 1)) break;
                        if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                            f = -32;
                            break;
                        }
                    }
                    if (f != 0) break;
                }
                if (f == 0) {
                    if (abs(vy) < 20 - vr) {
                        if (abs(vx) > 138.) f = 32;
                    } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                        f = 32;
                    }
                }
            }
            if (vz >= f) {
                f1 = 5;
                dx += (vx - ball[Ball.x]) * f1;
                dy += (vy - ball[Ball.y]) * f1;
                ball[@Ball.x] = vx;
                ball[@Ball.y] = vy;
                ball[@Ball.jump] = df + 0.03;
            } else ball[@Ball.jump] = 1;
        }
        if ((dx != 0 || dy != 0) && player[Player.bop] <= 0) {
            vx = dx;
            vy = dy;
            dx = player[Player.x] - ball[Ball.x];
            dy = player[Player.y] - ball[Ball.y];
            dz = clamp(ball[Ball.z], player[Player.z] + player[Player.rad], player[Player.z] + player[Player.alt] - player[Player.rad]) - ball[Ball.z];
            df = sqrt(dx * dx + dy * dy + dz * dz);
            if (df < ball[Ball.rad] + player[Player.rad]) {
                player[@Player.bop] = 1;
                df = sqrt(ball[Ball.rad] / 6) / power(ball[Ball.boost], 0.8);
                player[@Player.cx] += vx * df;
                player[@Player.cy] += vy * df;
                player[@Player.cz] = min(player[Player.cz] + 1, 2);
                player[@Player.health] -= df / 7;
                if (player[Player.health] <= 0) {
                    player[@Player.healthEase] = 0;
                    camData[@CameraData.z2] -= player[Player.alt] * 0.2;
                    camData[@CameraData.z1] -= player[Player.alt] * 0.2;
                    player[@Player.alt] *= 0.6;
                } else player[@Player.regen] = 0;
                player[@Player.ball] = ball;
            }
        }
        x1 = ball[Ball.x];
        y1 = ball[Ball.y];
        z1 = ball[Ball.z];
        for (k = 0; k < n; k += 1) {
            if (i != k) {
                ball2 = balls[|k];
                x2 = ball2[Ball.x] - x1;
                y2 = ball2[Ball.y] - y1;
                z2 = ball2[Ball.z] - z1;
                f2 = vr + ball2[Ball.rad];
                f = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
                if (f < f2) {
                    while (f == 0) {
                        x2 = random_range(-1, 1);
                        y2 = random_range(-1, 1);
                        f = sqrt(x2 * x2 + y2 * y2);
                    }
                    f = (f2 - f) / f / 10;
                    x2 *= f;
                    y2 *= f;
                    vx = x1 - x2;
                    vy = y1 - y2;
                    vz = ball[Ball.z];
                    if (true/*"findAlt"*/) {
                        f = 0;
                        for (f1 = -1; true; f1 = f1 + 2) {
                            if (!(f1 <= 1)) break;
                            if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                f = -32;
                                break;
                            }
                            for (f2 = -1; true; f2 = f2 + 2) {
                                if (!(f2 <= 1)) break;
                                if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                            }
                            if (f != 0) break;
                        }
                        if (f == 0) {
                            if (abs(vy) < 20 - vr) {
                                if (abs(vx) > 138.) f = 32;
                            } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                f = 32;
                            }
                        }
                    }
                    if (vz >= f) {
                        ball[@Ball.x] = vx;
                        x1 = vx;
                        ball[@Ball.y] = vy;
                        y1 = vy;
                    }
                    vx = ball2[Ball.x] + x2;
                    vy = ball2[Ball.y] + y2;
                    vz = ball2[Ball.z];
                    vr = ball2[Ball.rad];
                    if (true/*"findAlt"*/) {
                        f = 0;
                        for (f1 = -1; true; f1 = f1 + 2) {
                            if (!(f1 <= 1)) break;
                            if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                                f = -32;
                                break;
                            }
                            for (f2 = -1; true; f2 = f2 + 2) {
                                if (!(f2 <= 1)) break;
                                if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                    f = -32;
                                    break;
                                }
                            }
                            if (f != 0) break;
                        }
                        if (f == 0) {
                            if (abs(vy) < 20 - vr) {
                                if (abs(vx) > 138.) f = 32;
                            } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                                f = 32;
                            }
                        }
                    }
                    if (vz >= f) {
                        ball2[@Ball.x] = vx;
                        ball2[@Ball.y] = vy;
                    }
                    vr = ball[Ball.rad];
                }
            }
        }
        if (true/*"Push away from player"*/) {
            vx = ball[Ball.x];
            vy = ball[Ball.y];
            vz = ball[Ball.z];
            x2 = player[Player.x] - vx;
            y2 = player[Player.y] - vy;
            z2 = clamp(ball[Ball.z], player[Player.z] + player[Player.rad], player[Player.z] + player[Player.alt] - player[Player.rad]) - vz;
            f2 = player[Player.rad] + vr;
            f = sqrt(x2 * x2 + y2 * y2 + z2 * z2);
            if (f < f2) {
                while (f == 0) {
                    x2 = random_range(-1, 1);
                    y2 = random_range(-1, 1);
                    f = sqrt(x2 * x2 + y2 * y2);
                }
                f = (f2 - f) / f / 10;
                x2 *= f;
                y2 *= f;
                vx = x1 - x2;
                vy = y1 - y2;
                if (true/*"findAlt"*/) {
                    f = 0;
                    for (f1 = -1; true; f1 = f1 + 2) {
                        if (!(f1 <= 1)) break;
                        if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                            f = -32;
                            break;
                        }
                        for (f2 = -1; true; f2 = f2 + 2) {
                            if (!(f2 <= 1)) break;
                            if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                                f = -32;
                                break;
                            }
                        }
                        if (f != 0) break;
                    }
                    if (f == 0) {
                        if (abs(vy) < 20 - vr) {
                            if (abs(vx) > 138.) f = 32;
                        } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                            f = 32;
                        }
                    }
                }
                if (vz >= f) {
                    ball[@Ball.x] = vx;
                    ball[@Ball.y] = vy;
                }
            }
        }
        vx = ball[Ball.x];
        vy = ball[Ball.y];
        vz = ball[Ball.z];
        if (true/*"findAlt"*/) {
            f = 0;
            for (f1 = -1; true; f1 = f1 + 2) {
                if (!(f1 <= 1)) break;
                if (point_distance(vx, vy, f1 * 138., 0) < 20 - vr) {
                    f = -32;
                    break;
                }
                for (f2 = -1; true; f2 = f2 + 2) {
                    if (!(f2 <= 1)) break;
                    if (point_distance(vx, vy, 128 * f1, 172 * f2) < 20 - vr) {
                        f = -32;
                        break;
                    }
                }
                if (f != 0) break;
            }
            if (f == 0) {
                if (abs(vy) < 20 - vr) {
                    if (abs(vx) > 138.) f = 32;
                } else if (abs(vx) > 128 - vr || abs(vy) > 172 - vr) {
                    f = 32;
                }
            }
        }
        ball[@Ball.gz] = f;
        if (vz > f) {
            ball[@Ball.vz] -= (1 / 24);
        } else {
            ball[@Ball.wait] -= ((1 / 30)) * ball[Ball.rush];
            if (ball[Ball.wait] <= 0) {
                ball[@Ball.wait] = 1;
                if (alive || point_distance(vx, vy, player[Player.x], player[Player.y]) > 32) ball[@Ball.jump] = 0.001;
                ball[@Ball.vz] = 0.9;
            }
        }
        dz = ball[Ball.vz] + ball[Ball.cz];
        if (dz != 0) {
            vz += dz;
            if (dz < 0 && vz <= f) {
                ball[@Ball.z] = f;
                ball[@Ball.vz] = 0;
                ball[@Ball.cz] = abs(ball[Ball.cz]) * 0.7;
                if (ball[Ball.cz] < 0.1) ball[@Ball.cz] = 0;
            } else ball[@Ball.z] = vz;
            if (ball[Ball.z] + ball[Ball.rad] * 2 < -8) {
                k = 1 + ball[Ball.bounces];
                if (k > 3) k = 3;
                ctx[#GameCtx.score, 0] = (ctx[#GameCtx.score, 0] + k);
                if (player[Player.ball] == ball) player[@Player.ball] = undefined;
                ds_list_delete(balls, i);
                i -= 1;
                n -= 1;
            }
        }
        i += 1;
    }
    for (i = 0; i < n; i += 1) {
        ball = balls[|i];
        ball[@Ball.col] = false;
    }
}
if (alive && player[Player.health] <= 0) {
    ctx[#GameCtx.koSlideIn, 0] = 0;
    ctx[#GameCtx.koSlideOut, 0] = 0;
    ctx[#GameCtx.koSlideThru, 0] = 0;
}
texture_set_interpolation(false);
texture_set_repeat(true);
draw_set_color(-1);
if (true/*"Environment"*/) {
    draw_set_color(background_color);
    d3d_model_draw(ctx[#GameCtx.levelOuter, 0], 0, 0, 0, -1);
    draw_set_color(-1);
    for (i = 0; i < 4; i += 1) {
        d3d_model_draw(levelModels[|i], 0, 0, 0, levelTextures[|i]);
    }
}
if (true/*"Balls"*/) {
    n = ds_list_size(balls);
    if (true/*"Shadows"*/) {
        md = ctx[#GameCtx.ballShadow, 0];
        draw_set_color(0);
        draw_set_alpha(0.4);
        d3d_set_culling(true);
        for (i = 0; i < n; i += 1) {
            ball = balls[|i];
            d3d_transform_stack_push();
            f = ball[Ball.rad] / 6 * (40 / (40 + ball[Ball.z]));
            d3d_transform_add_scaling(f, f, f);
            d3d_transform_add_rotation_z(0);
            d3d_transform_add_translation(ball[Ball.x], ball[Ball.y], ball[Ball.gz] + 0.04);
            d3d_model_draw(md, 0, 0, 0, -1);
            d3d_transform_stack_pop();
        }
        d3d_set_culling(false);
        draw_set_color(-1);
        draw_set_alpha(1);
    }
    for (i = 0; i < n; i += 1) {
        ball = balls[|i];
        f1 = ball[Ball.jump];
        c1 = ds_list_find_value(ctx[#GameCtx.ballColors, 0], ball[Ball.number]);
        c2 = merge_colour(c1, 0, 0.7);
        for (k = 0; k < 6; k += 1) {
            d3d_transform_stack_push();
            switch (k) {
                case 0:
                    md = ctx[#GameCtx.ballInnerModel, 0];
                    tx = ds_list_find_value(ctx[#GameCtx.ballInnerTexture, 0], ball[Ball.number]);
                    draw_set_color(-1);
                    break;
                case 1:
                    md = ctx[#GameCtx.ballOuterModel, 0];
                    tx = ctx[#GameCtx.ballOuterTexture, 0];
                    draw_set_color(c1);
                    break;
                case 2: case 3:
                    md = ctx[#GameCtx.ballEye, 0];
                    tx = -1;
                    f = (k - 2.5) * 2;
                    d3d_transform_add_rotation_z(-90 - f * 10);
                    d3d_transform_add_rotation_y(90);
                    d3d_transform_add_translation(6, f * 0.5, 0);
                    d3d_transform_add_rotation_z(f * 30);
                    draw_set_color(c2);
                    break;
                case 4: case 5:
                    md = ctx[#GameCtx.ballBrow, 0];
                    tx = -1;
                    f = (k - 4.5) * 2;
                    d3d_transform_add_translation(0, -1.7, 0);
                    d3d_transform_add_rotation_z(-90 - f * 5);
                    d3d_transform_add_rotation_y(90);
                    d3d_transform_add_translation(6, f * 0.5, 0);
                    d3d_transform_add_rotation_y(random(10));
                    d3d_transform_add_rotation_z(f * 30);
                    draw_set_color(c2);
                    break;
                default:
                    md = undefined;
                    tx = undefined;
            }
            f = ball[Ball.rad] / 6;
            d3d_transform_add_scaling(f, f, f);
            f = sin(f1 * pi) * 7 - point_direction(0, ball[Ball.z], point_distance(ball[Ball.x], ball[Ball.y], player[Player.x], player[Player.y]), player[Player.z] + player[Player.alt] * 0.6);
            d3d_transform_add_rotation_y(f);
            d3d_transform_add_rotation_z(ball[Ball.yaw]);
            d3d_transform_add_translation(ball[Ball.x], ball[Ball.y], ball[Ball.z] + ball[Ball.rad]);
            d3d_model_draw(md, 0, 0, 0, tx);
            d3d_transform_stack_pop();
        }
    }
    draw_set_color(-1);
}
if (!ctx[#GameCtx.menu, 0] && player[Player.health] > 0 && player[Player.ease] >= 0.7 && true/*"Cue"*/) {
    d3d_transform_stack_push();
    d3d_transform_add_translation(1 - player[Player.cueY], 1.4 + player[Player.cueX], -power(player[Player.cueZ], 1.5));
    d3d_transform_add_rotation_y(-player[Player.tilt] - 90);
    d3d_transform_add_rotation_z(player[Player.yaw]);
    d3d_transform_add_translation(player[Player.x], player[Player.y], player[Player.z] + player[Player.alt] * 0.7);
    d3d_model_draw(ctx[#GameCtx.cueModel, 0], 0, 0, 0, ctx[#GameCtx.cueTexture, 0]);
    d3d_transform_stack_pop();
}
if (true/*"UI"*/) {
    d3d_set_projection_ortho(0, 0, ww, wh, 0);
    df = ceil(wh / 16 / 8) * 8;
    if (ctx[#GameCtx.score, 0] > 0 && true/*"Score"*/) {
        s = string(ctx[#GameCtx.score, 0]);
        n = string_length(s);
        d3d_transform_stack_push();
        d3d_transform_add_scaling(df, df, df);
        d3d_transform_add_translation(df / 4, df / 8, 0);
        f = 0;
        for (i = 0; i < n; i += 1) {
            md = ds_list_find_value(ctx[#GameCtx.glyphs, 0], string_ord_at(s, i + 1) - ord("0"));
            draw_set_color(0);
            draw_set_alpha(0.5);
            d3d_model_draw(md, f + 0.05, 0.05, 0, -1);
            draw_set_color(-1);
            draw_set_alpha(1);
            d3d_model_draw(md, f, 0, 0, -1);
            f += 0.6;
        }
        d3d_transform_stack_pop();
    }
    if (true/*"Health"*/) {
        md = d3d_model_create();
        d3d_model_primitive_begin(md, pr_trianglelist);
        f = 0.125;
        vx = 3;
        vy = 1;
        for (i = 0; i < 2; i += 1) {
            x1 = -vx;
            x2 = x1 + vx;
            y1 = (vy - 0.1) * i;
            y2 = y1 + 0.1;
            z1 = x1 + (0.5 - y2) * f;
            z2 = x2 + (0.5 - y2) * f;
            x1 += (0.5 - y1) * f;
            x2 += (0.5 - y1) * f;
            d3d_model_vertex(md, x1, y1, 0);
            d3d_model_vertex(md, x2, y1, 0);
            d3d_model_vertex(md, z1, y2, 0);
            d3d_model_vertex(md, z1, y2, 0);
            d3d_model_vertex(md, x2, y1, 0);
            d3d_model_vertex(md, z2, y2, 0);
            x1 = -0.1 - (vx - 0.1) * i;
            x2 = x1 + 0.1;
            y1 = 0.1;
            y2 = y1 + (vy - 0.2);
            z1 = x1 + (0.5 - y2) * f;
            z2 = x2 + (0.5 - y2) * f;
            x1 += (0.5 - y1) * f;
            x2 += (0.5 - y1) * f;
            d3d_model_vertex(md, x1, y1, 0);
            d3d_model_vertex(md, x2, y1, 0);
            d3d_model_vertex(md, z1, y2, 0);
            d3d_model_vertex(md, z1, y2, 0);
            d3d_model_vertex(md, x2, y1, 0);
            d3d_model_vertex(md, z2, y2, 0);
        }
        vz = (vx - 0.2) * clamp(player[Player.healthEase], 0, 1);
        x1 = -vx + 0.1;
        x2 = x1 + vz;
        y1 = 0.1;
        y2 = y1 + (vy - 0.2);
        z1 = x1 + (0.5 - y2) * f;
        z2 = x2 + (0.5 - y2) * f;
        x1 += (0.5 - y1) * f;
        x2 += (0.5 - y1) * f;
        d3d_model_vertex(md, x1, y1, 0);
        d3d_model_vertex(md, x2, y1, 0);
        d3d_model_vertex(md, z1, y2, 0);
        d3d_model_vertex(md, z1, y2, 0);
        d3d_model_vertex(md, x2, y1, 0);
        d3d_model_vertex(md, z2, y2, 0);
        d3d_model_primitive_end(md);
        d3d_transform_stack_push();
        d3d_transform_add_scaling(df, df, df);
        d3d_transform_add_translation(ww - df / 4, df / 8 - sqr(1 - player[Player.ease]) * df * 1.5, 0);
        draw_set_color(0);
        draw_set_alpha(0.5);
        d3d_model_draw(md, 0.05, 0.05, 0, -1);
        draw_set_color(-1);
        draw_set_alpha(1);
        d3d_model_draw(md, 0, 0, 0, -1);
        d3d_transform_stack_pop();
        d3d_model_destroy(md);
    }
    if (ctx[#GameCtx.menu, 0]) ctx[#GameCtx.logoEase, 0] = min(ctx[#GameCtx.logoEase, 0] + 0.02, 1); else ctx[#GameCtx.logoEase, 0] = max(ctx[#GameCtx.logoEase, 0] - 0.1, 0);
    if (ctx[#GameCtx.logoEase, 0] > 0) {
        for (k = 0; k < 2; k += 1) {
            if (k != 0) {
                sf = ctx[#GameCtx.logoShadow, 0];
                draw_set_color(0);
            } else {
                draw_set_color(-1);
                sf = ctx[#GameCtx.logoColor, 0];
            }
            if (!surface_exists(sf) || surface_get_width(sf) != ww || surface_get_height(sf) != wh) {
                if (surface_exists(sf)) surface_free(sf);
                sf = surface_create(ww, wh);
                if (k != 0) ctx[#GameCtx.logoShadow, 0] = sf; else ctx[#GameCtx.logoColor, 0] = sf;
            }
            surface_set_target(sf);
            d3d_set_projection_ortho(0, 0, ww, wh, 0);
            draw_clear_alpha(0, 0);
            if (k != 0) i = 1; else i = 0;
            while (i >= 0) {
                d3d_transform_stack_push();
                f = min(ww, wh) / 2 / 128;
                f *= 1 + i / 32;
                d3d_transform_add_scaling(f, -f, 1);
                d3d_transform_add_translation(ww / 2, wh / 2, 0);
                d3d_model_draw(ctx[#GameCtx.logo, 0], -128, -64, 0, -1);
                d3d_transform_stack_pop();
                i -= 2;
            }
            if (k == 1) {
                draw_set_blend_mode(bm_subtract);
                draw_background_ext(ctx[#GameCtx.white16, 0], 0, 0, ww / 16, wh / 16, 0, 0, 0.5);
                draw_set_blend_mode(bm_add);
                draw_surface(ctx[#GameCtx.logoColor, 0], 0, 0);
                draw_set_blend_mode(bm_normal);
            }
            surface_reset_target();
        }
        d3d_set_projection_ortho(0, 0, ww, wh, 0);
        f = power(ctx[#GameCtx.logoEase, 0], 2);
        draw_surface_ext(ctx[#GameCtx.logoShadow, 0], 0, 0, 1, 1, 0, -1, 0.9 * f);
    }
    if (!ctx[#GameCtx.menu, 0]) {
        if (true/*"Minimap"*/) {
            vz = wh / 8 / 172;
            vx = 172 * vz + 8;
            vy = wh - 172 * vz - 8 + 360. * sqr(1 - player[Player.ease]);
            vr = 0;
            draw_background_ext(ctx[#GameCtx.white16, 0], vx - 128 * vz, vy - 172 * vz, 256. * vz / 16, 344. * vz / 16, 0, 0, 0.5);
            if (true/*"Balls"*/) {
                n = ds_list_size(balls);
                for (i = 0; i < n; i += 1) {
                    ball = balls[|i];
                    x1 = ball[Ball.x];
                    y1 = ball[Ball.y];
                    if (x1 < -128. || x1 > 128 || y1 < -172. || y1 > 172) continue;
                    draw_set_color(ds_list_find_value(ctx[#GameCtx.ballColors, 0], ball[Ball.number]));
                    d3d_transform_stack_push();
                    f = ball[Ball.rad];
                    d3d_transform_add_scaling(f, f, f);
                    d3d_transform_add_translation(x1, y1, 0);
                    d3d_transform_add_scaling(vz, vz, vz);
                    d3d_transform_add_rotation_z(vr);
                    d3d_transform_add_translation(vx, vy, 0);
                    d3d_model_draw(ctx[#GameCtx.mapBall, 0], 0, 0, 0, -1);
                    d3d_transform_stack_pop();
                }
            }
            if (true/*"Table"*/) {
                d3d_transform_stack_push();
                d3d_transform_add_scaling(vz, vz, vz);
                d3d_transform_add_rotation_z(vr);
                d3d_transform_add_translation(vx, vy, 0);
                draw_set_color(-1);
                d3d_model_draw(ctx[#GameCtx.mapTable, 0], 0, 0, 0, -1);
                d3d_transform_stack_pop();
            }
            if (true/*"Player"*/) {
                d3d_transform_stack_push();
                f = player[Player.rad];
                d3d_transform_add_scaling(f, f, f);
                d3d_transform_add_rotation_z(player[Player.yaw]);
                d3d_transform_add_translation(player[Player.x], player[Player.y], 0);
                d3d_transform_add_scaling(vz, vz, vz);
                d3d_transform_add_rotation_z(vr);
                d3d_transform_add_translation(vx, vy, 0);
                draw_set_color(-1);
                d3d_model_draw(ctx[#GameCtx.mapPlayer, 0], 0, 0, 0, -1);
                d3d_transform_stack_pop();
            }
        }
        if (player[Player.health] > 0) {
            x1 = ww / 2;
            y1 = wh / 2;
            draw_background_ext(ctx[#GameCtx.white16, 0], x1 - 1, y1 - 1, 0.125, 0.125, 0, -1, 0.5);
            if (aim > 0) {
                draw_background_ext(ctx[#GameCtx.white16, 0], x1 + 8, y1 - 1, aim * 16 / 16, 0.125, 0, -1, 0.5);
                draw_background_ext(ctx[#GameCtx.white16, 0], x1 - 8, y1 - 1, aim * -16 / 16, 0.125, 0, -1, 0.5);
                draw_background_ext(ctx[#GameCtx.white16, 0], x1 - 1, y1 + 8, 0.125, aim * 16 / 16, 0, -1, 0.5);
                draw_background_ext(ctx[#GameCtx.white16, 0], x1 - 1, y1 - 8, 0.125, aim * -16 / 16, 0, -1, 0.5);
            }
        } else {
            vz = wh / 4;
            f = ctx[#GameCtx.koSlideIn, 0];
            x1 = 0.45;
            x2 = 0.55;
            if (f < 1) {
                vx = lerp(-0.3, x1, power(f, 2));
                ctx[#GameCtx.koSlideIn, 0] = (f + (1 / 30));
            } else {
                f = ctx[#GameCtx.koSlideThru, 0];
                if (f < 1) {
                    vx = lerp(x1, x2, f);
                    ctx[#GameCtx.koSlideThru, 0] = (f + (1 / 180));
                } else {
                    f = ctx[#GameCtx.koSlideOut, 0];
                    if (f < 1) {
                        vx = lerp(x2, 1.3, 1 - power(1 - f, 2));
                        ctx[#GameCtx.koSlideOut, 0] = (f + 0.05);
                    } else vx = 2;
                }
                ball = player[Player.ball];
                if (!is_undefined(ball)) {
                    f = 0.01;
                    camData[@CameraData.x2] = lerp(camData[CameraData.x2], ball[Ball.x], f);
                    camData[@CameraData.y2] = lerp(camData[CameraData.y2], ball[Ball.y], f);
                    camData[@CameraData.z2] = lerp(camData[CameraData.z2], ball[Ball.z] + 6, f);
                }
                if (mouse_check_button_pressed(mb_left)) ctx[#GameCtx.menu, 0] = true;
            }
            d3d_transform_stack_push();
            d3d_transform_add_scaling(vz, vz, vz);
            d3d_transform_add_translation(vx * ww, (wh - vz) / 2, 0);
            for (i = 0; i < 2; i += 1) {
                f = -0.75;
                vy = 0;
                if (i == 0) {
                    draw_set_color(0);
                    draw_set_alpha(1);
                    vy += 2 / vz;
                    f += vy;
                } else {
                    draw_set_color(-1);
                    draw_set_alpha(1);
                }
                d3d_model_draw(ds_list_find_value(ctx[#GameCtx.glyphs, 0], 11), f, vy, 0, -1);
                f += 0.6;
                d3d_model_draw(ds_list_find_value(ctx[#GameCtx.glyphs, 0], 10), f, vy, 0, -1);
                f += 0.2;
                d3d_model_draw(ds_list_find_value(ctx[#GameCtx.glyphs, 0], 12), f, vy, 0, -1);
                f += 0.6;
                d3d_model_draw(ds_list_find_value(ctx[#GameCtx.glyphs, 0], 10), f, vy, 0, -1);
            }
            d3d_transform_stack_pop();
        }
    }
}
