;; ***** BEGIN LICENSE BLOCK *****
;; Roadsend PHP Compiler Runtime Libraries
;; Copyright (C) 2007 Roadsend, Inc.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public License
;; as published by the Free Software Foundation; either version 2.1
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
;; ***** END LICENSE BLOCK *****
(module gdk-enums-lib
   (load (php-macros "../../../php-macros.scm"))
   (load (php-gtk-macros "php-gtk-macros.sch"))
   (extern (include "gtk/gtk.h"))
;   (include "../phpoo-extension.sch")
;   (include "php-gtk-macros.sch")
   (library php-runtime)
;   (library "common")
   (import (define-classes "define-classes.scm"))
   (export
    (init-gdk-enums-lib) ))

;;;
;;; Module Init
;;; ===========

(define (init-gdk-enums-lib)
   (init-define-classes)
   1)

;; this ``(defclass Gdk); pcc-gtk))'' became this, in order to get the
;; class-constants defined at the right time:
(add-startup-function-for-extension
 "gtk2"
 (lambda ()
    (define-extended-php-class 'Gdk '() #f #f (lambda (a) a))

;;;
;;; Gdk Enums and Flags
;;; ===================

    (define-enum ColorSpace
       (in-module "Gdk")
       (c-name "GdkColorSpace")
       (gtype-id "GDK_TYPE_COLORSPACE")
       (values '("rgb" "GDK_COLORSPACE_RGB")))

    (define-enum CursorType
       (in-module "Gdk")
       (c-name "GdkCursorType")
       (gtype-id "GDK_TYPE_CURSOR_TYPE")
       (values
        '("gdk-cursor-is-pixmap" "GDK_CURSOR_IS_PIXMAP")))

    (define-flags DragAction
       (in-module "Gdk")
       (c-name "GdkDragAction")
       (gtype-id "GDK_TYPE_DRAG_ACTION")
       (values
        '("default" "GDK_ACTION_DEFAULT")
        '("copy" "GDK_ACTION_COPY")
        '("move" "GDK_ACTION_MOVE")
        '("link" "GDK_ACTION_LINK")
        '("private" "GDK_ACTION_PRIVATE")
        '("ask" "GDK_ACTION_ASK")))

    (define-enum DragProtocol
       (in-module "Gdk")
       (c-name "GdkDragProtocol")
       (gtype-id "GDK_TYPE_DRAG_PROTOCOL")
       (values
        '("motif" "GDK_DRAG_PROTO_MOTIF")
        '("xdnd" "GDK_DRAG_PROTO_XDND")
        '("rootwin" "GDK_DRAG_PROTO_ROOTWIN")
        '("none" "GDK_DRAG_PROTO_NONE")
        '("win32-dropfiles"
          "GDK_DRAG_PROTO_WIN32_DROPFILES")
        '("ole2" "GDK_DRAG_PROTO_OLE2")
        '("local" "GDK_DRAG_PROTO_LOCAL")))

    (define-enum FilterReturn
       (in-module "Gdk")
       (c-name "GdkFilterReturn")
       (gtype-id "GDK_TYPE_FILTER_RETURN")
       (values
        '("continue" "GDK_FILTER_CONTINUE")
        '("translate" "GDK_FILTER_TRANSLATE")
        '("remove" "GDK_FILTER_REMOVE")))

    (define-enum EventType
       (in-module "Gdk")
       (c-name "GdkEventType")
       (gtype-id "GDK_TYPE_EVENT_TYPE")
       (values
        '("nothing" "GDK_NOTHING")
        '("delete" "GDK_DELETE")
        '("destroy" "GDK_DESTROY")
        '("expose" "GDK_EXPOSE")
        '("motion-notify" "GDK_MOTION_NOTIFY")
        '("button-press" "GDK_BUTTON_PRESS")
        '("2button-press" "GDK_2BUTTON_PRESS")
        '("3button-press" "GDK_3BUTTON_PRESS")
        '("button-release" "GDK_BUTTON_RELEASE")
        '("key-press" "GDK_KEY_PRESS")
        '("key-release" "GDK_KEY_RELEASE")
        '("enter-notify" "GDK_ENTER_NOTIFY")
        '("leave-notify" "GDK_LEAVE_NOTIFY")
        '("focus-change" "GDK_FOCUS_CHANGE")
        '("configure" "GDK_CONFIGURE")
        '("map" "GDK_MAP")
        '("unmap" "GDK_UNMAP")
        '("property-notify" "GDK_PROPERTY_NOTIFY")
        '("selection-clear" "GDK_SELECTION_CLEAR")
        '("selection-request" "GDK_SELECTION_REQUEST")
        '("selection-notify" "GDK_SELECTION_NOTIFY")
        '("proximity-in" "GDK_PROXIMITY_IN")
        '("proximity-out" "GDK_PROXIMITY_OUT")
        '("drag-enter" "GDK_DRAG_ENTER")
        '("drag-leave" "GDK_DRAG_LEAVE")
        '("drag-motion" "GDK_DRAG_MOTION")
        '("drag-status" "GDK_DRAG_STATUS")
        '("drop-start" "GDK_DROP_START")
        '("drop-finished" "GDK_DROP_FINISHED")
        '("client-event" "GDK_CLIENT_EVENT")
        '("visibility-notify" "GDK_VISIBILITY_NOTIFY")
        '("no-expose" "GDK_NO_EXPOSE")
        '("scroll" "GDK_SCROLL")
        '("window-state" "GDK_WINDOW_STATE")
        '("setting" "GDK_SETTING")
        '("owner-change" "GDK_OWNER_CHANGE")))

    (define-flags EventMask
       (in-module "Gdk")
       (c-name "GdkEventMask")
       (gtype-id "GDK_TYPE_EVENT_MASK")
       (values
        '("exposure-mask" "GDK_EXPOSURE_MASK")
        '("pointer-motion-mask" "GDK_POINTER_MOTION_MASK")
        '("pointer-motion-hint-mask"
          "GDK_POINTER_MOTION_HINT_MASK")
        '("button-motion-mask" "GDK_BUTTON_MOTION_MASK")
        '("button1-motion-mask" "GDK_BUTTON1_MOTION_MASK")
        '("button2-motion-mask" "GDK_BUTTON2_MOTION_MASK")
        '("button3-motion-mask" "GDK_BUTTON3_MOTION_MASK")
        '("button-press-mask" "GDK_BUTTON_PRESS_MASK")
        '("button-release-mask" "GDK_BUTTON_RELEASE_MASK")
        '("key-press-mask" "GDK_KEY_PRESS_MASK")
        '("key-release-mask" "GDK_KEY_RELEASE_MASK")
        '("enter-notify-mask" "GDK_ENTER_NOTIFY_MASK")
        '("leave-notify-mask" "GDK_LEAVE_NOTIFY_MASK")
        '("focus-change-mask" "GDK_FOCUS_CHANGE_MASK")
        '("structure-mask" "GDK_STRUCTURE_MASK")
        '("property-change-mask"
          "GDK_PROPERTY_CHANGE_MASK")
        '("visibility-notify-mask"
          "GDK_VISIBILITY_NOTIFY_MASK")
        '("proximity-in-mask" "GDK_PROXIMITY_IN_MASK")
        '("proximity-out-mask" "GDK_PROXIMITY_OUT_MASK")
        '("substructure-mask" "GDK_SUBSTRUCTURE_MASK")
        '("scroll-mask" "GDK_SCROLL_MASK")
        '("all-events-mask" "GDK_ALL_EVENTS_MASK")))

    (define-enum VisibilityState
       (in-module "Gdk")
       (c-name "GdkVisibilityState")
       (gtype-id "GDK_TYPE_VISIBILITY_STATE")
       (values
        '("unobscured" "GDK_VISIBILITY_UNOBSCURED")
        '("partial" "GDK_VISIBILITY_PARTIAL")
        '("fully-obscured"
          "GDK_VISIBILITY_FULLY_OBSCURED")))

    (define-enum ScrollDirection
       (in-module "Gdk")
       (c-name "GdkScrollDirection")
       (gtype-id "GDK_TYPE_SCROLL_DIRECTION")
       (values
        '("up" "GDK_SCROLL_UP")
        '("down" "GDK_SCROLL_DOWN")
        '("left" "GDK_SCROLL_LEFT")
        '("right" "GDK_SCROLL_RIGHT")))

    (define-enum NotifyType
       (in-module "Gdk")
       (c-name "GdkNotifyType")
       (gtype-id "GDK_TYPE_NOTIFY_TYPE")
       (values
        '("ancestor" "GDK_NOTIFY_ANCESTOR")
        '("virtual" "GDK_NOTIFY_VIRTUAL")
        '("inferior" "GDK_NOTIFY_INFERIOR")
        '("nonlinear" "GDK_NOTIFY_NONLINEAR")
        '("nonlinear-virtual"
          "GDK_NOTIFY_NONLINEAR_VIRTUAL")
        '("unknown" "GDK_NOTIFY_UNKNOWN")))

    (define-enum CrossingMode
       (in-module "Gdk")
       (c-name "GdkCrossingMode")
       (gtype-id "GDK_TYPE_CROSSING_MODE")
       (values
        '("normal" "GDK_CROSSING_NORMAL")
        '("grab" "GDK_CROSSING_GRAB")
        '("ungrab" "GDK_CROSSING_UNGRAB")))

    (define-enum PropertyState
       (in-module "Gdk")
       (c-name "GdkPropertyState")
       (gtype-id "GDK_TYPE_PROPERTY_STATE")
       (values
        '("new-value" "GDK_PROPERTY_NEW_VALUE")
        '("delete" "GDK_PROPERTY_DELETE")))

    (define-flags WindowState
       (in-module "Gdk")
       (c-name "GdkWindowState")
       (gtype-id "GDK_TYPE_WINDOW_STATE")
       (values
        '("withdrawn" "GDK_WINDOW_STATE_WITHDRAWN")
        '("iconified" "GDK_WINDOW_STATE_ICONIFIED")
        '("maximized" "GDK_WINDOW_STATE_MAXIMIZED")
        '("sticky" "GDK_WINDOW_STATE_STICKY")
        '("fullscreen" "GDK_WINDOW_STATE_FULLSCREEN")
        '("above" "GDK_WINDOW_STATE_ABOVE")
        '("below" "GDK_WINDOW_STATE_BELOW")))

    (define-enum SettingAction
       (in-module "Gdk")
       (c-name "GdkSettingAction")
       (gtype-id "GDK_TYPE_SETTING_ACTION")
       (values
        '("new" "GDK_SETTING_ACTION_NEW")
        '("changed" "GDK_SETTING_ACTION_CHANGED")
        '("deleted" "GDK_SETTING_ACTION_DELETED")))

    (define-enum FontType
       (in-module "Gdk")
       (c-name "GdkFontType")
       (gtype-id "GDK_TYPE_FONT_TYPE")
       (values
        '("font" "GDK_FONT_FONT")
        '("fontset" "GDK_FONT_FONTSET")))

    (define-enum CapStyle
       (in-module "Gdk")
       (c-name "GdkCapStyle")
       (gtype-id "GDK_TYPE_CAP_STYLE")
       (values
        '("not-last" "GDK_CAP_NOT_LAST")
        '("butt" "GDK_CAP_BUTT")
        '("round" "GDK_CAP_ROUND")
        '("projecting" "GDK_CAP_PROJECTING")))

    (define-enum Fill
       (in-module "Gdk")
       (c-name "GdkFill")
       (gtype-id "GDK_TYPE_FILL")
       (values
        '("solid" "GDK_SOLID")
        '("tiled" "GDK_TILED")
        '("stippled" "GDK_STIPPLED")
        '("opaque-stippled" "GDK_OPAQUE_STIPPLED")))

    (define-enum Function
       (in-module "Gdk")
       (c-name "GdkFunction")
       (gtype-id "GDK_TYPE_FUNCTION")
       (values
        '("copy" "GDK_COPY")
        '("invert" "GDK_INVERT")
        '("xor" "GDK_XOR")
        '("clear" "GDK_CLEAR")
        '("and" "GDK_AND")
        '("and-reverse" "GDK_AND_REVERSE")
        '("and-invert" "GDK_AND_INVERT")
        '("noop" "GDK_NOOP")
        '("or" "GDK_OR")
        '("equiv" "GDK_EQUIV")
        '("or-reverse" "GDK_OR_REVERSE")
        '("copy-invert" "GDK_COPY_INVERT")
        '("or-invert" "GDK_OR_INVERT")
        '("nand" "GDK_NAND")
        '("nor" "GDK_NOR")
        '("set" "GDK_SET")))

    (define-enum JoinStyle
       (in-module "Gdk")
       (c-name "GdkJoinStyle")
       (gtype-id "GDK_TYPE_JOIN_STYLE")
       (values
        '("miter" "GDK_JOIN_MITER")
        '("round" "GDK_JOIN_ROUND")
        '("bevel" "GDK_JOIN_BEVEL")))

    (define-enum LineStyle
       (in-module "Gdk")
       (c-name "GdkLineStyle")
       (gtype-id "GDK_TYPE_LINE_STYLE")
       (values
        '("solid" "GDK_LINE_SOLID")
        '("on-off-dash" "GDK_LINE_ON_OFF_DASH")
        '("double-dash" "GDK_LINE_DOUBLE_DASH")))

    (define-enum SubwindowMode
       (in-module "Gdk")
       (c-name "GdkSubwindowMode")
       (gtype-id "GDK_TYPE_SUBWINDOW_MODE")
       (values
        '("clip-by-children" "GDK_CLIP_BY_CHILDREN")
        '("include-inferiors" "GDK_INCLUDE_INFERIORS")))

    (define-flags GCValuesMask
       (in-module "Gdk")
       (c-name "GdkGCValuesMask")
       (gtype-id "GDK_TYPE_GC_VALUES_MASK")
       (values
        '("foreground" "GDK_GC_FOREGROUND")
        '("background" "GDK_GC_BACKGROUND")
        '("font" "GDK_GC_FONT")
        '("function" "GDK_GC_FUNCTION")
        '("fill" "GDK_GC_FILL")
        '("tile" "GDK_GC_TILE")
        '("stipple" "GDK_GC_STIPPLE")
        '("clip-mask" "GDK_GC_CLIP_MASK")
        '("subwindow" "GDK_GC_SUBWINDOW")
        '("ts-x-origin" "GDK_GC_TS_X_ORIGIN")
        '("ts-y-origin" "GDK_GC_TS_Y_ORIGIN")
        '("clip-x-origin" "GDK_GC_CLIP_X_ORIGIN")
        '("clip-y-origin" "GDK_GC_CLIP_Y_ORIGIN")
        '("exposures" "GDK_GC_EXPOSURES")
        '("line-width" "GDK_GC_LINE_WIDTH")
        '("line-style" "GDK_GC_LINE_STYLE")
        '("cap-style" "GDK_GC_CAP_STYLE")
        '("join-style" "GDK_GC_JOIN_STYLE")))

    (define-enum ImageType
       (in-module "Gdk")
       (c-name "GdkImageType")
       (gtype-id "GDK_TYPE_IMAGE_TYPE")
       (values
        '("normal" "GDK_IMAGE_NORMAL")
        '("shared" "GDK_IMAGE_SHARED")
        '("fastest" "GDK_IMAGE_FASTEST")))

    (define-enum ExtensionMode
       (in-module "Gdk")
       (c-name "GdkExtensionMode")
       (gtype-id "GDK_TYPE_EXTENSION_MODE")
       (values
        '("none" "GDK_EXTENSION_EVENTS_NONE")
        '("all" "GDK_EXTENSION_EVENTS_ALL")
        '("cursor" "GDK_EXTENSION_EVENTS_CURSOR")))

    (define-enum InputSource
       (in-module "Gdk")
       (c-name "GdkInputSource")
       (gtype-id "GDK_TYPE_INPUT_SOURCE")
       (values
        '("mouse" "GDK_SOURCE_MOUSE")
        '("pen" "GDK_SOURCE_PEN")
        '("eraser" "GDK_SOURCE_ERASER")
        '("cursor" "GDK_SOURCE_CURSOR")))

    (define-enum InputMode
       (in-module "Gdk")
       (c-name "GdkInputMode")
       (gtype-id "GDK_TYPE_INPUT_MODE")
       (values
        '("disabled" "GDK_MODE_DISABLED")
        '("screen" "GDK_MODE_SCREEN")
        '("window" "GDK_MODE_WINDOW")))

    (define-enum AxisUse
       (in-module "Gdk")
       (c-name "GdkAxisUse")
       (gtype-id "GDK_TYPE_AXIS_USE")
       (values
        '("ignore" "GDK_AXIS_IGNORE")
        '("x" "GDK_AXIS_X")
        '("y" "GDK_AXIS_Y")
        '("pressure" "GDK_AXIS_PRESSURE")
        '("xtilt" "GDK_AXIS_XTILT")
        '("ytilt" "GDK_AXIS_YTILT")
        '("wheel" "GDK_AXIS_WHEEL")
        '("last" "GDK_AXIS_LAST")))

    (define-enum PropMode
       (in-module "Gdk")
       (c-name "GdkPropMode")
       (gtype-id "GDK_TYPE_PROP_MODE")
       (values
        '("replace" "GDK_PROP_MODE_REPLACE")
        '("prepend" "GDK_PROP_MODE_PREPEND")
        '("append" "GDK_PROP_MODE_APPEND")))

    (define-enum FillRule
       (in-module "Gdk")
       (c-name "GdkFillRule")
       (gtype-id "GDK_TYPE_FILL_RULE")
       (values
        '("even-odd-rule" "GDK_EVEN_ODD_RULE")
        '("winding-rule" "GDK_WINDING_RULE")))

    (define-enum OverlapType
       (in-module "Gdk")
       (c-name "GdkOverlapType")
       (gtype-id "GDK_TYPE_OVERLAP_TYPE")
       (values
        '("in" "GDK_OVERLAP_RECTANGLE_IN")
        '("out" "GDK_OVERLAP_RECTANGLE_OUT")
        '("part" "GDK_OVERLAP_RECTANGLE_PART")))

    (define-enum RgbDither
       (in-module "Gdk")
       (c-name "GdkRgbDither")
       (gtype-id "GDK_TYPE_RGB_DITHER")
       (values
        '("none" "GDK_RGB_DITHER_NONE")
        '("normal" "GDK_RGB_DITHER_NORMAL")
        '("max" "GDK_RGB_DITHER_MAX")))

    (define-enum ByteOrder
       (in-module "Gdk")
       (c-name "GdkByteOrder")
       (gtype-id "GDK_TYPE_BYTE_ORDER")
       (values
        '("lsb-first" "GDK_LSB_FIRST")
        '("msb-first" "GDK_MSB_FIRST")))

    (define-flags ModifierType
       (in-module "Gdk")
       (c-name "GdkModifierType")
       (gtype-id "GDK_TYPE_MODIFIER_TYPE")
       (values
        '("shift-mask" "GDK_SHIFT_MASK")
        '("lock-mask" "GDK_LOCK_MASK")
        '("control-mask" "GDK_CONTROL_MASK")
        '("mod1-mask" "GDK_MOD1_MASK")
        '("mod2-mask" "GDK_MOD2_MASK")
        '("mod3-mask" "GDK_MOD3_MASK")
        '("mod4-mask" "GDK_MOD4_MASK")
        '("mod5-mask" "GDK_MOD5_MASK")
        '("button1-mask" "GDK_BUTTON1_MASK")
        '("button2-mask" "GDK_BUTTON2_MASK")
        '("button3-mask" "GDK_BUTTON3_MASK")
        '("button4-mask" "GDK_BUTTON4_MASK")
        '("button5-mask" "GDK_BUTTON5_MASK")
        '("release-mask" "GDK_RELEASE_MASK")
        '("modifier-mask" "GDK_MODIFIER_MASK")))

    (define-flags InputCondition
       (in-module "Gdk")
       (c-name "GdkInputCondition")
       (gtype-id "GDK_TYPE_INPUT_CONDITION")
       (values
        '("read" "GDK_INPUT_READ")
        '("write" "GDK_INPUT_WRITE")
        '("exception" "GDK_INPUT_EXCEPTION")))

    (define-enum Status
       (in-module "Gdk")
       (c-name "GdkStatus")
       (gtype-id "GDK_TYPE_STATUS")
       (values
        '("ok" "GDK_OK")
        '("error" "GDK_ERROR")
        '("error-param" "GDK_ERROR_PARAM")
        '("error-file" "GDK_ERROR_FILE")
        '("error-mem" "GDK_ERROR_MEM")))

    (define-enum GrabStatus
       (in-module "Gdk")
       (c-name "GdkGrabStatus")
       (gtype-id "GDK_TYPE_GRAB_STATUS")
       (values
        '("success" "GDK_GRAB_SUCCESS")
        '("already-grabbed" "GDK_GRAB_ALREADY_GRABBED")
        '("invalid-time" "GDK_GRAB_INVALID_TIME")
        '("not-viewable" "GDK_GRAB_NOT_VIEWABLE")
        '("frozen" "GDK_GRAB_FROZEN")))

    (define-enum VisualType
       (in-module "Gdk")
       (c-name "GdkVisualType")
       (gtype-id "GDK_TYPE_VISUAL_TYPE")
       (values
        '("static-gray" "GDK_VISUAL_STATIC_GRAY")
        '("grayscale" "GDK_VISUAL_GRAYSCALE")
        '("static-color" "GDK_VISUAL_STATIC_COLOR")
        '("pseudo-color" "GDK_VISUAL_PSEUDO_COLOR")
        '("true-color" "GDK_VISUAL_TRUE_COLOR")
        '("direct-color" "GDK_VISUAL_DIRECT_COLOR")))

    (define-enum WindowClass
       (in-module "Gdk")
       (c-name "GdkWindowClass")
       (gtype-id "GDK_TYPE_WINDOW_CLASS")
       (values
        '("output" "GDK_INPUT_OUTPUT")
        '("only" "GDK_INPUT_ONLY")))

    (define-enum WindowType
       (in-module "Gdk")
       (c-name "GdkWindowType")
       (gtype-id "GDK_TYPE_WINDOW_TYPE")
       (values
        '("root" "GDK_WINDOW_ROOT")
        '("toplevel" "GDK_WINDOW_TOPLEVEL")
        '("child" "GDK_WINDOW_CHILD")
        '("dialog" "GDK_WINDOW_DIALOG")
        '("temp" "GDK_WINDOW_TEMP")
        '("foreign" "GDK_WINDOW_FOREIGN")))

    (define-flags WindowAttributesType
       (in-module "Gdk")
       (c-name "GdkWindowAttributesType")
       (gtype-id "GDK_TYPE_WINDOW_ATTRIBUTES_TYPE")
       (values
        '("title" "GDK_WA_TITLE")
        '("x" "GDK_WA_X")
        '("y" "GDK_WA_Y")
        '("cursor" "GDK_WA_CURSOR")
        '("colormap" "GDK_WA_COLORMAP")
        '("visual" "GDK_WA_VISUAL")
        '("wmclass" "GDK_WA_WMCLASS")
        '("noredir" "GDK_WA_NOREDIR")))

    (define-flags WindowHints
       (in-module "Gdk")
       (c-name "GdkWindowHints")
       (gtype-id "GDK_TYPE_WINDOW_HINTS")
       (values
        '("pos" "GDK_HINT_POS")
        '("min-size" "GDK_HINT_MIN_SIZE")
        '("max-size" "GDK_HINT_MAX_SIZE")
        '("base-size" "GDK_HINT_BASE_SIZE")
        '("aspect" "GDK_HINT_ASPECT")
        '("resize-inc" "GDK_HINT_RESIZE_INC")
        '("win-gravity" "GDK_HINT_WIN_GRAVITY")
        '("user-pos" "GDK_HINT_USER_POS")
        '("user-size" "GDK_HINT_USER_SIZE")))

    (define-enum WindowTypeHint
       (in-module "Gdk")
       (c-name "GdkWindowTypeHint")
       (gtype-id "GDK_TYPE_WINDOW_TYPE_HINT")
       (values
        '("normal" "GDK_WINDOW_TYPE_HINT_NORMAL")
        '("dialog" "GDK_WINDOW_TYPE_HINT_DIALOG")
        '("menu" "GDK_WINDOW_TYPE_HINT_MENU")
        '("toolbar" "GDK_WINDOW_TYPE_HINT_TOOLBAR")
        '("splashscreen"
          "GDK_WINDOW_TYPE_HINT_SPLASHSCREEN")
        '("utility" "GDK_WINDOW_TYPE_HINT_UTILITY")
        '("dock" "GDK_WINDOW_TYPE_HINT_DOCK")
        '("desktop" "GDK_WINDOW_TYPE_HINT_DESKTOP")))

    (define-flags WMDecoration
       (in-module "Gdk")
       (c-name "GdkWMDecoration")
       (gtype-id "GDK_TYPE_WM_DECORATION")
       (values
        '("all" "GDK_DECOR_ALL")
        '("border" "GDK_DECOR_BORDER")
        '("resizeh" "GDK_DECOR_RESIZEH")
        '("title" "GDK_DECOR_TITLE")
        '("menu" "GDK_DECOR_MENU")
        '("minimize" "GDK_DECOR_MINIMIZE")
        '("maximize" "GDK_DECOR_MAXIMIZE")))

    (define-flags WMFunction
       (in-module "Gdk")
       (c-name "GdkWMFunction")
       (gtype-id "GDK_TYPE_WM_FUNCTION")
       (values
        '("all" "GDK_FUNC_ALL")
        '("resize" "GDK_FUNC_RESIZE")
        '("move" "GDK_FUNC_MOVE")
        '("minimize" "GDK_FUNC_MINIMIZE")
        '("maximize" "GDK_FUNC_MAXIMIZE")
        '("close" "GDK_FUNC_CLOSE")))

    (define-enum Gravity
       (in-module "Gdk")
       (c-name "GdkGravity")
       (gtype-id "GDK_TYPE_GRAVITY")
       (values
        '("north-west" "GDK_GRAVITY_NORTH_WEST")
        '("north" "GDK_GRAVITY_NORTH")
        '("north-east" "GDK_GRAVITY_NORTH_EAST")
        '("west" "GDK_GRAVITY_WEST")
        '("center" "GDK_GRAVITY_CENTER")
        '("east" "GDK_GRAVITY_EAST")
        '("south-west" "GDK_GRAVITY_SOUTH_WEST")
        '("south" "GDK_GRAVITY_SOUTH")
        '("south-east" "GDK_GRAVITY_SOUTH_EAST")
        '("static" "GDK_GRAVITY_STATIC")))

    (define-enum WindowEdge
       (in-module "Gdk")
       (c-name "GdkWindowEdge")
       (gtype-id "GDK_TYPE_WINDOW_EDGE")
       (values
        '("north-west" "GDK_WINDOW_EDGE_NORTH_WEST")
        '("north" "GDK_WINDOW_EDGE_NORTH")
        '("north-east" "GDK_WINDOW_EDGE_NORTH_EAST")
        '("west" "GDK_WINDOW_EDGE_WEST")
        '("east" "GDK_WINDOW_EDGE_EAST")
        '("south-west" "GDK_WINDOW_EDGE_SOUTH_WEST")
        '("south" "GDK_WINDOW_EDGE_SOUTH")
        '("south-east" "GDK_WINDOW_EDGE_SOUTH_EAST")))

    (define-enum PixbufAlphaMode
       (in-module "Gdk")
       (c-name "GdkPixbufAlphaMode")
       (gtype-id "GDK_TYPE_PIXBUF_ALPHA_MODE")
       (values
        '("bilevel" "GDK_PIXBUF_ALPHA_BILEVEL")
        '("full" "GDK_PIXBUF_ALPHA_FULL")))

    (define-enum PixbufError
       (in-module "Gdk")
       (c-name "GdkPixbufError")
       (gtype-id "GDK_TYPE_PIXBUF_ERROR")
       (values
        ;;     '("header-corrupt"
        ;;       "GDK_PIXBUF_ERROR_HEADER_CORRUPT")
        ;;     '("pixel-corrupt"
        ;;       "GDK_PIXBUF_ERROR_PIXEL_CORRUPT")
        ;;     '("unknown-format"
        ;;       "GDK_PIXBUF_ERROR_UNKNOWN_FORMAT")
        '("corrupt-image"
          "GDK_PIXBUF_ERROR_CORRUPT_IMAGE")
        '("insufficient-memory"
          "GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY")
        ;;     '("bad-option-value"
        ;;       "GDK_PIXBUF_ERROR_BAD_OPTION_VALUE")
        '("unknown-type" "GDK_PIXBUF_ERROR_UNKNOWN_TYPE")
        '("unsupported-operation"
          "GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION")
        '("failed" "GDK_PIXBUF_ERROR_FAILED")))

    (define-enum InterpType
       (in-module "Gdk")
       (c-name "GdkInterpType")
       (gtype-id "GDK_TYPE_INTERP_TYPE")
       (values
        '("nearest" "GDK_INTERP_NEAREST")
        '("tiles" "GDK_INTERP_TILES")
        '("bilinear" "GDK_INTERP_BILINEAR")
        '("hyper" "GDK_INTERP_HYPER")))

    ))