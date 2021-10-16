local animationManager = {
    animationTasks = {},--takes in animationTask objects
}

function animationManager:addTask(animationTask, animationId)
    if self.animationTasks[animationId] == nil then
        self.animationTasks[animationId] = animationTask
    end
end

function animationManager:updateTasks(dt)
    for animationId, animationTask in pairs(self.animationTasks) do
        local taskStatus = animationTask:updateTask(dt)
        if taskStatus.isFinished then
            self.animationTasks[animationId] = nil
        end
    end
end

return animationManager