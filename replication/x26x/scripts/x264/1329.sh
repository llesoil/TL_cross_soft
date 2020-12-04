#!/bin/sh

numb='1330'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 45 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.1,1.1,2.4,0.5,0.9,0.4,0,1,12,45,270,4,27,40,5,2,65,38,6,2000,-2:-2,umh,show,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"