#!/bin/sh

numb='2938'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 45 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.5,1.3,0.4,0.2,0.7,0.3,1,0,14,45,210,0,21,30,3,3,67,28,2,2000,-2:-2,umh,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"