#!/bin/sh

numb='568'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 0 --keyint 210 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.2,4.8,0.2,0.7,0.1,1,1,2,0,210,4,29,20,3,4,66,48,2,1000,-2:-2,dia,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"