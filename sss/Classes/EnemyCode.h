#import "EnemyScript.h"

// 0
static EnemyScriptCode enemycode0[] = {
    OP_HP(1),
    OP_TEX(6, 0, 4, 3),
    OP_HITRECT(32, 24),
    OP_DIR(270),
    OP_SPEED(200),
    OP_SHOT(-1),
    OP_WAIT(100),
    OP_ROTATE(90),
};


// 1
static EnemyScriptCode enemycode1[] = {
    OP_HP(20),
    OP_TEX(0, 10, 12, 8),
    OP_HITRECT(96, 64),
    OP_DIR(90),
    OP_SPEED(100),
    OP_WAIT(200),
    OP_SPEED(10),
    OP_SHOT(-1),
    OP_WAIT(150),
    OP_JMP(7),
};




static struct {
    EnemyScriptCode* code;
    size_t size;
} table[] = {
    { enemycode0, sizeof(enemycode0)/sizeof(enemycode0[0]) },
    { enemycode1, sizeof(enemycode1)/sizeof(enemycode1[0]) },
};
