#!/bin/sh

numb='1837'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 10 --keyint 220 --lookahead-threads 1 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.5,1.0,4.4,0.6,0.6,0.6,0,1,6,10,220,1,25,0,4,4,61,38,6,1000,1:1,umh,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"