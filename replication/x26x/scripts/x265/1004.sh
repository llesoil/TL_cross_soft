#!/bin/sh

numb='1005'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 0 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.3,1.0,2.6,0.4,0.9,0.1,2,1,16,0,260,1,20,0,4,1,68,48,4,2000,-2:-2,umh,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"