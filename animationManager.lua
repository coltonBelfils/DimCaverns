local animationManager = {
    animationTasks = {},--takes in animationTask objects
    addTask = function(self, animationTask, animationId)
        if self.animationTasks[animationId] == nil then
            self.animationTasks[animationId] = animationTask
        end
    end,
    updateTasks = function(self, dt)
        for animationId, animationTask in pairs(self.animationTasks) do
            local taskStatus = animationTask:updateTask(dt)
            if taskStatus.isFinished then
                self.animationTasks[animationId] = nil
            end
        end
    end
}

return animationManager