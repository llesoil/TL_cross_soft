#!/bin/sh

numb='1508'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.0,1.1,2.8,0.4,0.8,0.7,1,2,12,5,270,4,30,40,4,0,65,48,5,2000,1:1,umh,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"