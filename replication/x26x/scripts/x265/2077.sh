#!/bin/sh

numb='2078'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 5 --keyint 240 --lookahead-threads 3 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,2.5,1.5,1.2,0.2,0.4,0.9,0.4,1,0,16,5,240,3,27,50,4,4,65,48,1,1000,-2:-2,umh,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"