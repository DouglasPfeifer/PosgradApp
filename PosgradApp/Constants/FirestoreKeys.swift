//
//  FirestoreKeys.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation

struct UserKeys {
    static let avatarKey = "avatar"
    static let courseKey = "curso"
    static let nameKey = "nome"
    static let emailKey = "email"
    static let teamIDKey = "idtime"
}

struct MissionKeys {
    static let collectionKey = "missoes"
    static let descrptionKey = "descricao"
    static let nameKey = "nome"
    static let orderKey = "order"
    static let seasonKey = "temporada"
}

struct TeamKeys {
    static let collectionKey = "times"
    static let avatarKey = "avatar"
}

struct TeamMemberKeys {
    static let collectionKey = "membros"
    static let courseKey = "curso"
    static let emailKey = "email"
    static let teamIDKey = "idtime"
    static let nameKey = "nome"
}

struct ActivityKeys {
    static let collectionKey = "atividades"
    static let fileKey = "arquivo"
    static let appraiserKey = "avaliador"
    static let feedbackKey = "feedback"
    static let memberKey = "membro"
    static let missionKey = "missao"
    static let nameKey = "nome"
    static let scoreKey = "pontuacao"
    static let typeKey = "tipo"
}

struct TeamActivityKeys {
    static let collectionKey = "atividadesComTime"
    static let fileKey = "arquivo"
    static let appraiserKey = "avaliador"
    static let feedbackKey = "feedback"
    static let memberKey = "membro"
    static let missionKey = "missao"
    static let nameKey = "nome"
    static let scoreKey = "pontuacao"
    static let teamKey = "time"
    static let typeKey = "tipo"
}

struct SelfServiceKeys {
    static let collectionKey = "meta-info"
    static let adminsKey = "admins"
    static let coursesKey = "cursos"
    struct CoursesKeys {
        static let cicles = "ciclos"
        static let description = "desc"
        static let emphasis = "enfases"
        static let image = "img"
        static let missions = "missoes"
        static let seasons = "temporadas"
    }
}

struct SubjectsKeys {
    static let collectionKey = "self"
    static let learningObjectKey = "arrayObjAprendizagem"
    static let cicleKey = "ciclo"
    static let emphasis = "enfase"
    static let formation = "formacao"
    static let image = "img"
    static let name = "nome"
    struct LearningObjectKeys {
        static let format = "formato"
        static let link = "link"
        static let name = "nome"
        static let type = "tipo"
    }
}
