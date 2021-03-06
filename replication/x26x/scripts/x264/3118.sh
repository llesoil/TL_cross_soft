#!/bin/sh

numb='3119'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 45 --keyint 270 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.0,1.0,4.2,0.3,0.6,0.5,3,2,10,45,270,2,25,40,4,0,65,48,2,2000,1:1,umh,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"