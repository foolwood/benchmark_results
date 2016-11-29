function res = run_NONE(subS, rp, bSaveImage)
init_rect = subS.init_rect;
img_files = subS.s_frames;

res.type = 'rect';
res.res = repmat(init_rect,[numel(img_files),1]);
res.fps    = numel(img_files) / time;
end