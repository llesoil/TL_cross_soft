#!/bin/sh

numb='737'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.4,1.0,2.4,0.5,0.8,0.0,3,2,16,15,250,0,26,50,3,0,63,48,3,2000,-2:-2,umh,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"