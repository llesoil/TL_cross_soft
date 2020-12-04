#!/bin/sh

numb='3115'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 25 --keyint 230 --lookahead-threads 4 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.2,1.2,1.4,0.4,0.7,0.1,2,0,6,25,230,4,27,10,5,0,60,48,6,1000,1:1,umh,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"