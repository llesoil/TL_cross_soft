#!/bin/sh

numb='1547'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.0,1.1,1.8,0.6,0.9,0.6,2,0,2,45,210,1,28,30,4,1,61,18,2,2000,1:1,umh,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"