#!/bin/sh

numb='2100'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 20 --keyint 270 --lookahead-threads 1 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.2,1.2,2.2,0.3,0.7,0.5,2,0,16,20,270,1,24,0,5,0,66,28,2,2000,-1:-1,hex,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"