#!/bin/sh

numb='670'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 45 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.4,1.0,0.5,0.7,0.6,2,0,10,45,200,0,30,50,5,1,65,48,3,1000,-2:-2,hex,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"