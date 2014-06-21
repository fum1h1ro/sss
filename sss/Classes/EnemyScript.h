//
enum {
    REG_A,
    REG_B,
    REG_C,
    REG_D,
    REG_E,
    REG_F,
    REG_G,
    REG_H,
    REG_MAX,
};
//
typedef NS_ENUM(u8, EnemyOpcode) {
    _OP_WAIT,            // WAIT(sec)
    _OP_TEX,             // TEX(x, y, w, h)
    _OP_SPEED,           // SPEED(spd)
    _OP_DIR,             // DIR(dir)
    _OP_ROTATE,          // ROTATE(angle)
    _OP_SHOT,            // SHOT reg(dir), imm(speed)
    _OP_HP,
    _OP_HITRECT,
    _OP_HITCIRCLE,
    _OP_JMP,             // JMP label
    //
    _OP_YIELD,
    _OP_LI,              // LI reg, imm
    _OP_MOVE,            // MOVE reg, imm
    _OP_ADD,             // ADD reg, imm
    _OP_SUB,             // SUB reg, imm
    _OP_MUL,             // MUL reg, imm
    _OP_DIV,             // DIV reg, imm
};
//
typedef struct {
    EnemyOpcode opcode;
    s32 param;
} EnemyScriptCode;


#define OP_WAIT(n) { _OP_WAIT, (n) }
#define OP_TEX(x,y,w,h) { _OP_TEX, ((x)<<0)|((y)<<8)|((w)<<16)|((h)<<24) }
#define OP_SPEED(n) { _OP_SPEED, (n) }
#define OP_DIR(n) { _OP_DIR, (n) }
#define OP_ROTATE(n) { _OP_ROTATE, (n) }
#define OP_SHOT(n) { _OP_SHOT, (n) }
#define OP_HP(n) { _OP_HP, (n) }
#define OP_HITRECT(w,h) { _OP_HITRECT, ((w)<<0)|((h)<<16) }
#define OP_HITCIRCLE(n) { _OP_HITCIRCLE, (n) }
#define OP_JMP(n) { _OP_JMP, (n) }
