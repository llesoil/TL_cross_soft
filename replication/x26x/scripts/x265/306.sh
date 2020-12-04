#!/bin/sh

numb='307'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 10 --keyint 250 --lookahead-threads 4 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.2,1.3,1.0,0.4,0.6,0.7,3,0,8,10,250,4,27,50,5,3,66,48,5,1000,-1:-1,umh,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"