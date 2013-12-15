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
    OP_YIELD,
    OP_LI,              // LI reg, imm
    OP_ADD,             // ADD reg, imm
    OP_SUB,             // SUB reg, imm
    OP_MUL,             // MUL reg, imm
    OP_DIV,             // DIV reg, imm
    OP_SPEED,           // SPEED reg
    OP_DIR,             // DIR reg
    OP_ROTATE,          // ROTATE reg
    OP_WAIT,            // WAIT reg
    OP_JMP,             // JMP label
    OP_SHOT,            // SHOT reg(dir), imm(speed)
};
//
typedef struct {
    u8 label;
    EnemyOpcode opcode;
    s16 a;
    f32 b;
} EnemyScriptCode;

