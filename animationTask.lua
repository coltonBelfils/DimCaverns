local AnimationTask = {
    new = function(self, currentPos, destinationPos, duration, animationOffset)
        local nTask = {}

        nTask.currentPos = currentPos
        nTask.destinationPos = destinationPos
        nTask.duration = duration
        -- nTask.progress = 0 --this will take some more work to do becaue this is essenchaly offset/delta and delta can be 0
        nTask.offset = animationOffset

        nTask.xDelta = nTask.destinationPos.x - nTask.currentPos.x
        nTask.yDelta = nTask.destinationPos.y - nTask.currentPos.y

        if nTask.duration <= 0 then
            nTask.offset.x = nTask.xDelta
            nTask.offset.y = nTask.yDelta
        end

        setmetatable(nTask, self)

        return nTask
    end
}

AnimationTask.__index = AnimationTask
AnimationTask.__tostring = function(self)
    return "task"
end

AnimationTask.updateTask = function(self, dt)
    if self.duration <= 0 then
        self.currentPos.x = self.destinationPos.x
        self.currentPos.y = self.destinationPos.y
        self.offset.x = 0
        self.offset.y = 0
        return {
            isFinished = true
        }
    end

    self.offset.x = self.offset.x + ((self.xDelta / self.duration) * dt)
    self.offset.y = self.offset.y + ((self.yDelta / self.duration) * dt)

    if math.abs(self.offset.x) >= math.abs(self.xDelta) and math.abs(self.offset.y) >= math.abs(self.yDelta) then
        self.currentPos.x = self.destinationPos.x
        self.currentPos.y = self.destinationPos.y
        self.offset.x = 0
        self.offset.y = 0
        return {
            isFinished = true
        }
    end

    return {
        isFinished = false
    }
end

return AnimationTask
