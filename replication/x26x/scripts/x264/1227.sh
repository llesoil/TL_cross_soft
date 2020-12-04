#!/bin/sh

numb='1228'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 20 --keyint 270 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.0,1.2,0.3,0.6,0.8,2,0,16,20,270,1,22,40,5,1,65,28,4,2000,-1:-1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"