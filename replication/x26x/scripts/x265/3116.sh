#!/bin/sh

numb='3117'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 30 --keyint 280 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.4,1.0,4.0,0.5,0.8,0.4,2,2,8,30,280,4,28,0,3,4,65,18,5,1000,-2:-2,dia,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"