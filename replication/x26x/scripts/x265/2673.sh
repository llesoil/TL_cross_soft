#!/bin/sh

numb='2674'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 0 --keyint 200 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.4,1.1,1.2,0.5,0.6,0.2,0,0,2,0,200,0,29,10,5,2,63,48,6,1000,-2:-2,dia,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"