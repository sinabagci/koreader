describe("luasettings module", function()
    local Settings
    setup(function()
        require("commonrequire")
        Settings = require("frontend/luasettings"):open("this-is-not-a-valid-file")
    end)

    it("should handle undefined keys", function()
        Settings:delSetting("abc")

        assert.True(Settings:hasNot("abc"))
        assert.True(Settings:nilOrTrue("abc"))
        assert.False(Settings:isTrue("abc"))
        Settings:saveSetting("abc", true)
        assert.True(Settings:has("abc"))
        assert.True(Settings:nilOrTrue("abc"))
        assert.True(Settings:isTrue("abc"))
    end)

    it("should flip bool values", function()
        Settings:delSetting("abc")

        assert.True(Settings:hasNot("abc"))
        Settings:flipNilOrTrue("abc")
        assert.False(Settings:nilOrTrue("abc"))
        assert.True(Settings:has("abc"))
        assert.False(Settings:isTrue("abc"))
        Settings:flipNilOrTrue("abc")
        assert.True(Settings:nilOrTrue("abc"))
        assert.True(Settings:hasNot("abc"))
        assert.False(Settings:isTrue("abc"))

        Settings:flipTrue("abc")
        assert.True(Settings:has("abc"))
        assert.True(Settings:isTrue("abc"))
        assert.True(Settings:nilOrTrue("abc"))
        Settings:flipTrue("abc")
        assert.False(Settings:has("abc"))
        assert.False(Settings:isTrue("abc"))
        assert.True(Settings:nilOrTrue("abc"))
    end)

    it("should create child settings", function()
        Settings:saveSetting("key", {
            a = "b",
            c = "true",
            d = false,
        })

        local child = Settings:child("key")

        assert.is_not_nil(child)
        assert.True(child:has("a"))
        assert.are.equal(child:readSetting("a"), "b")
        assert.True(child:has("c"))
        assert.True(child:isTrue("c"))
        assert.True(child:has("d"))
        assert.True(child:isFalse("d"))
        assert.False(child:isTrue("e"))
        child:flipTrue("e")
        child:close()

        child = Settings:child("key")
        assert.True(child:isTrue("e"))
    end)
end)
