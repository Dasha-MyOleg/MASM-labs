; Файл макросів: macro_defs.inc

DlgStatic MACRO id, hwnd, text
    LOCAL static_hWnd
    static_hWnd = CreateWindowEx(
        0, 
        addr StaticClass, 
        addr text, 
        WS_CHILD or WS_VISIBLE, 
        10, 10 + (id - 1) * 20, 
        200, 20, 
        hwnd, 
        id, 
        hInstance, 
        NULL)
ENDM

DlgEdit MACRO id, hwnd
    LOCAL edit_hWnd
    edit_hWnd = CreateWindowEx(
        WS_EX_CLIENTEDGE, 
        addr EditClass, 
        NULL, 
        WS_CHILD or WS_VISIBLE or ES_AUTOHSCROLL, 
        10, 10 + (id - 1) * 20, 
        200, 20, 
        hwnd, 
        id, 
        hInstance, 
        NULL)
ENDM

DlgButton MACRO id, hwnd, text
    LOCAL button_hWnd
    button_hWnd = CreateWindowEx(
        0, 
        addr ButtonClass, 
        addr text, 
        WS_TABSTOP or WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON, 
        10, 10 + (id - 1) * 20, 
        80, 20, 
        hwnd, 
        id, 
        hInstance, 
        NULL)
ENDM
