#!/bin/sh

numb='2275'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 40 --keyint 250 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.5,1.4,4.2,0.3,0.6,0.1,0,2,0,40,250,1,23,30,5,1,65,48,3,2000,-2:-2,umh,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"