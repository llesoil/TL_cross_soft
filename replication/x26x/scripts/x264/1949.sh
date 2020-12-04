#!/bin/sh

numb='1950'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 0 --keyint 250 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.1,2.4,0.4,0.8,0.4,3,0,6,0,250,0,28,40,4,2,67,48,3,2000,-1:-1,dia,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"