#!/bin/sh

numb='2519'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 20 --keyint 230 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,0.0,1.6,1.1,3.8,0.6,0.6,0.0,3,0,0,20,230,2,27,10,4,1,61,18,1,2000,1:1,umh,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"