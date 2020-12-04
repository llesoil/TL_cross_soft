#!/bin/sh

numb='2382'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 15 --keyint 220 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.5,1.4,1.4,0.4,0.7,0.3,3,0,0,15,220,1,20,0,4,2,64,38,5,1000,1:1,umh,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"