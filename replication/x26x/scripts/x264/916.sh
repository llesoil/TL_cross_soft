#!/bin/sh

numb='917'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--weightb,1.5,1.4,1.1,1.6,0.5,0.8,0.6,0,0,4,5,220,2,21,0,3,3,60,28,1,2000,1:1,umh,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"