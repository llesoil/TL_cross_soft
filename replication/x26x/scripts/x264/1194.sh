#!/bin/sh

numb='1195'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 45 --keyint 230 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.3,0.4,0.5,0.9,0.8,0,1,0,45,230,2,21,30,3,0,69,38,4,2000,-1:-1,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"