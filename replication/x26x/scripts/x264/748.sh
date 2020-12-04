#!/bin/sh

numb='749'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 35 --keyint 270 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.3,1.0,2.8,0.2,0.7,0.3,0,1,4,35,270,3,29,50,3,2,69,38,3,1000,-2:-2,umh,crop,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"